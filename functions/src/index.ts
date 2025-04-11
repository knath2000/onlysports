import * as functions from "firebase-functions";
import axios, {isAxiosError} from "axios";
import cors from "cors";

// Initialize CORS middleware
// TODO: Restrict origins in production for security.
// eslint-disable-next-line max-len
const corsHandler = cors({origin: true});

// Access token via process.env (set via functions:config:set)
const FOOTBALL_DATA_API_TOKEN = process.env.FOOTBALL_DATA_TOKEN;
const FOOTBALL_DATA_BASE_URL = "https://api.football-data.org/v4";

export const footballDataProxy = functions.https.onRequest(
  (request, response) => {
    corsHandler(request, response, async () => {
      // Log the environment variable value AS SEEN BY THIS INVOCATION
      console.log(`FOOTBALL_DATA_TOKEN from env: ${process.env.FOOTBALL_DATA_TOKEN}`);
      try {
        if (request.method !== "POST") {
          response.status(405).send("Method Not Allowed");
          return;
        }

        const targetPath = request.body.path;
        const queryParams = request.body.params;

        if (!targetPath) {
          response.status(400).send("Missing 'path' in request body.");
          return;
        }

        // Check if token was loaded correctly from config
        if (!FOOTBALL_DATA_API_TOKEN) {
          console.error("CRITICAL: Football Data API token is not configured.");
          response
            .status(500)
            .send("Server configuration error: API token missing.");
          return;
        }

        const targetUrl = `${FOOTBALL_DATA_BASE_URL}${targetPath}`;

        const apiResponse = await axios.get(targetUrl, {
          headers: {
            "X-Auth-Token": FOOTBALL_DATA_API_TOKEN,
          },
          params: queryParams,
        });

        // Forward the status code and data from the football-data.org API
        response.status(apiResponse.status).send(apiResponse.data);
      } catch (error) {
        console.error("Error during proxy request processing:", error);
        if (isAxiosError(error) && error.response) {
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
