import * as functions from "firebase-functions";
import axios, {isAxiosError} from "axios"; // Import isAxiosError specifically
import cors from "cors"; // Use default import

// Initialize CORS middleware.
// Allow all origins for development simplicity.
// TODO: Restrict origins in production for security.
// e.g., cors({origin: 'https://your-deployed-app-domain.com'})
const corsHandler = cors({origin: true});
// This should now work with the default import

// TODO: IMPORTANT - Move API Token to secure configuration
// Use Firebase Functions environment configuration:
// firebase functions:config:set football_data.token="YOUR_API_TOKEN"
// Then access via functions.config().football_data.token
// Access token from Firebase environment config
// eslint-disable-next-line max-len

// Access token from process.env (set via functions:config:set)
const FOOTBALL_DATA_API_TOKEN = process.env.FOOTBALL_DATA_TOKEN;
const FOOTBALL_DATA_BASE_URL = "https://api.football-data.org/v4";

export const footballDataProxy = functions.https.onRequest(
  (request, response) => {
    // Wrap the main logic with the CORS handler
    corsHandler(request, response, async () => {
      // We expect the target path and params in the request body for POST
      // Or in query params for GET
      // (adjust as needed based on client implementation)
      // Using POST body here for potentially complex params
      if (request.method !== "POST") {
        response.status(405).send("Method Not Allowed");
        return;
      }

      const targetPath = request.body.path; // e.g., "/competitions/PL/matches"
      const queryParams = request.body.params; // e.g., { status: "SCHEDULED" }

      if (!targetPath) {
        response.status(400).send("Missing 'path' in request body.");
        return;
      }
      // Check if token was loaded correctly from config
      if (!FOOTBALL_DATA_API_TOKEN) {
        console.error("Football Data API token is not configured.");
        response
          .status(500)
          .send("Server configuration error: API token missing.");
        return;
      }

      const targetUrl = `${FOOTBALL_DATA_BASE_URL}${targetPath}`;

      try {
        const apiResponse = await axios.get(targetUrl, {
          headers: {
            "X-Auth-Token": FOOTBALL_DATA_API_TOKEN,
          },
          params: queryParams, // Pass query parameters to axios
        });

        // Forward the status code and data from the football-data.org API
        response.status(apiResponse.status).send(apiResponse.data);
      } catch (error) {
        console.error("Error calling football-data.org API:", error);
        if (isAxiosError(error) && error.response) { // Use named import
          // Forward the error status and data from the football-data.org API
          response.status(error.response.status).send(error.response.data);
        } else {
          // Generic server error
          response.status(500).send("Internal Server Error proxying request.");
        }
      }
    });
  }
);
