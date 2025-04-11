import type { VercelRequest, VercelResponse } from '@vercel/node';
import axios, { isAxiosError } from 'axios';

// Access token from Vercel Environment Variables
// Set this in your Vercel project settings (e.g., FOOTBALL_DATA_TOKEN)
const FOOTBALL_DATA_API_TOKEN = process.env.FOOTBALL_DATA_TOKEN;
const FOOTBALL_DATA_BASE_URL = "https://api.football-data.org/v4";

export default async function handler(
  request: VercelRequest,
  response: VercelResponse,
) {
  // Vercel automatically handles CORS preflight (OPTIONS) requests
  // Allow POST method for sending parameters in the body
  if (request.method !== 'POST') {
    return response.status(405).send('Method Not Allowed');
  }

  // Allow requests from your deployed Vercel domain and localhost for development
  // TODO: Tighten this in production if needed
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

  // Handle the actual POST request
  const targetPath = request.body.path; // e.g., "/competitions/PL/matches"
  const queryParams = request.body.params; // e.g., { status: "SCHEDULED" }

  if (!targetPath) {
    return response.status(400).send({ error: "Missing 'path' in request body." });
  }

  if (!FOOTBALL_DATA_API_TOKEN) {
    console.error("CRITICAL: FOOTBALL_DATA_TOKEN environment variable is not set in Vercel.");
    return response.status(500).send({ error: "Server configuration error: API token missing." });
  }

  const targetUrl = `${FOOTBALL_DATA_BASE_URL}${targetPath}`;

  try {
    const apiResponse = await axios.get(targetUrl, {
      headers: {
        "X-Auth-Token": FOOTBALL_DATA_API_TOKEN,
      },
      params: queryParams,
    });

    // Forward the successful response
    return response.status(apiResponse.status).send(apiResponse.data);

  } catch (error) {
    console.error("Error calling football-data.org API via Vercel proxy:", error);
    if (isAxiosError(error) && error.response) {
      // Forward the error response from the external API
      return response.status(error.response.status).send(error.response.data);
    } else {
      // Generic server error
      return response.status(500).send({ error: "Internal Server Error proxying request." });
    }
  }
}