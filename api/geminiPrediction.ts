import type { VercelRequest, VercelResponse } from '@vercel/node';
import { GoogleGenerativeAI, HarmCategory, HarmBlockThreshold } from '@google/generative-ai';

// Access API key from Vercel Environment Variables
const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const MODEL_NAME = "gemini-pro"; // Or choose another appropriate model

export default async function handler(
  request: VercelRequest,
  response: VercelResponse,
) {
  // --- CORS Headers ---
  // Adjust allowed origins as needed for production
   const allowedOrigin = request.headers.origin && 
                         (request.headers.origin.includes('vercel.app') || 
                          request.headers.origin.startsWith('http://localhost:')) 
                       ? request.headers.origin 
                       : 'https://onlysports.vercel.app'; // Fallback or your main domain

  response.setHeader('Access-Control-Allow-Credentials', 'true');
  response.setHeader('Access-Control-Allow-Origin', allowedOrigin);
  response.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  response.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  );
   // Handle CORS preflight requests first
   if (request.method === 'OPTIONS') {
     return response.status(200).end();
   }
   // Now, allow only POST for the actual logic
   if (request.method !== 'POST') {
     return response.status(405).send({ error: 'Method Not Allowed' });
   }
  // --- End CORS Headers ---

  if (!GEMINI_API_KEY) {
    console.error("CRITICAL: GEMINI_API_KEY environment variable is not set in Vercel.");
    return response.status(500).send({ error: "Server configuration error: API key missing." });
  }

  // Destructure request body safely
  const { homeTeamName, awayTeamName, competitionName } = request.body || {};

  if (!homeTeamName || !awayTeamName || !competitionName) {
    return response.status(400).send({ error: "Missing required fields: homeTeamName, awayTeamName, competitionName." });
  }

  try {
    // Use non-null assertion (!) because we checked GEMINI_API_KEY above
    const genAI = new GoogleGenerativeAI(GEMINI_API_KEY!); 
    const model = genAI.getGenerativeModel({ model: MODEL_NAME });

    const generationConfig = {
      temperature: 0.7, // Adjust for creativity vs consistency
      topK: 1,
      topP: 1,
      maxOutputTokens: 200, // Limit response length
    };

    // Safety settings to block harmful content
    const safetySettings = [
      { category: HarmCategory.HARM_CATEGORY_HARASSMENT, threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE },
      { category: HarmCategory.HARM_CATEGORY_HATE_SPEECH, threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE },
      { category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT, threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE },
      { category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT, threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE },
    ];

    const prompt = `Predict the outcome (win for ${homeTeamName}, win for ${awayTeamName}, or draw) for the upcoming soccer match between ${homeTeamName} and ${awayTeamName} in the ${competitionName}. Provide a one-sentence justification. Be concise. Example: Draw, as both teams have similar recent form.`;

    const result = await model.generateContent({
        contents: [{ role: "user", parts: [{ text: prompt }] }],
        generationConfig,
        safetySettings,
    });

    // Check for blocked content or other issues before accessing text
    if (!result.response || !result.response.candidates || result.response.candidates.length === 0 || !result.response.candidates[0].content) {
        console.error("Gemini API response blocked or invalid:", result.response?.promptFeedback);
        const blockReason = result.response?.promptFeedback?.blockReason || 'Unknown reason';
        return response.status(500).send({ error: `Prediction generation failed or was blocked: ${blockReason}` });
    }
    
    // Extract text safely
    const predictionText = result.response.text(); // Use the text() helper

    return response.status(200).send({ prediction: predictionText });

  } catch (error) {
    console.error("Error calling Gemini API:", error);
    // Avoid sending detailed internal errors to the client
    return response.status(500).send({ error: "Failed to get prediction from AI model." });
  }
} // Ensure this closing brace is present