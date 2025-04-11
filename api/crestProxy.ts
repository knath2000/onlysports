import type { VercelRequest, VercelResponse } from '@vercel/node';
import axios, { isAxiosError } from 'axios';

export default async function handler(
  request: VercelRequest,
  response: VercelResponse,
) {
  // Allow only GET requests for images
  if (request.method !== 'GET') {
    return response.status(405).send('Method Not Allowed');
  }

  const imageUrl = request.query.url;

  if (!imageUrl || typeof imageUrl !== 'string') {
    return response.status(400).send({ error: "Missing or invalid 'url' query parameter." });
  }

  // Basic validation to prevent abuse (optional, but recommended)
  if (!imageUrl.startsWith('https://crests.football-data.org/')) {
     return response.status(400).send({ error: "Invalid image URL domain." });
  }

  try {
    const imageResponse = await axios.get(imageUrl, {
      responseType: 'arraybuffer', // Crucial for handling binary image data
      timeout: 10000, // Set a reasonable timeout (e.g., 10 seconds)
    });

    // Determine Content-Type from the original response or infer from URL
    let contentType = imageResponse.headers['content-type'];
    if (!contentType) {
        if (imageUrl.endsWith('.svg')) {
            contentType = 'image/svg+xml';
        } else if (imageUrl.endsWith('.png')) {
            contentType = 'image/png';
        } else {
            contentType = 'application/octet-stream'; // Fallback
        }
    }

    // Set permissive CORS headers for images
    response.setHeader('Access-Control-Allow-Origin', '*');
    response.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
    response.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');

    // Set cache headers (optional but good practice)
    // Cache for 1 day on CDN and client
    response.setHeader('Cache-Control', 'public, s-maxage=86400, max-age=86400, stale-while-revalidate'); 

    // Set the correct Content-Type
    response.setHeader('Content-Type', contentType);

    // Send the image data
    return response.status(200).send(Buffer.from(imageResponse.data, 'binary'));

  } catch (error) {
    console.error(`Error fetching image from ${imageUrl}:`, error);
    if (isAxiosError(error) && error.response) {
      // Forward the error status if possible
      return response.status(error.response.status).send({ error: `Failed to fetch image: upstream status ${error.response.status}` });
    } else {
      // Generic server error
      return response.status(500).send({ error: "Internal Server Error proxying image request." });
    }
  }
}