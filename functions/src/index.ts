import * as functions from "firebase-functions";
import axios, {isAxiosError} from "axios";
import cors from "cors";

// Initialize CORS middleware
const corsHandler = cors({origin: true});

// Access token from process environment variables (set via functions:config:set)
// eslint-disable-next-line max-len
const FOOTBALL_DATA_API_TOKEN = process.env.FOOTBALL_DATA_TOKEN;
const FOOTBALL_DATA_BASE_URL = "https://api.football-data.org/v4";

console.log("Function definition started."); // Log 1: Global scope start

if (!FOOTBALL_DATA_API_TOKEN) {
  console.error("CRITICAL: FOOTBALL_DATA_API_TOKEN is not set in environment!");
} else {
  console.log("FOOTBALL_DATA_API_TOKEN loaded from environment.");
}
console.log(`Base URL set to: ${FOOTBALL_DATA_BASE_URL}`);

export const footballDataProxy = functions.https.onRequest(
  (request, response) => {
    console.log("Function invoked."); // Log 2: Request received

    corsHandler(request, response, async () => {
      console.log("CORS handler executed."); // Log 3: After CORS

      try {
        console.log(`Request method: ${request.method}`);
        if (request.method !== "POST") {
          console.log("Method not POST, sending 405.");
          response.status(405).send("Method Not Allowed");
          return;
        }

        const targetPath = request.body.path;
        const queryParams = request.body.params;
        console.log(`Target Path: ${targetPath}, Params: ${JSON.stringify(queryParams)}`); // Log 4: Params received

        if (!targetPath) {
          console.log("Missing targetPath, sending 400.");
          response.status(400).send("Missing 'path' in request body.");
          return;
        }

        // Check token again inside handler just in case
        if (!FOOTBALL_DATA_API_TOKEN) {
          console.error("Handler Check: API token missing, sending 500.");
          response.status(500).send("Server configuration error: API token missing.");
          return;
        }

        const targetUrl = `${FOOTBALL_DATA_BASE_URL}${targetPath}`;
        console.log(`Calling external API: ${targetUrl}`); // Log 5: Before axios call

        const apiResponse = await axios.get(targetUrl, {
          headers: {
            "X-Auth-Token": FOOTBALL_DATA_API_TOKEN,
          },
          params: queryParams,
        });

        console.log(`API Response Status: ${apiResponse.status}`); // Log 6: After successful axios call
        response.status(apiResponse.status).send(apiResponse.data);
      } catch (error) {
        console.error("Error during proxy request processing:", error); // Log 7: Catch block entered
        if (isAxiosError(error) && error.response) {
          console.error(`External API Error: Status ${error.response.status}`);
          response.status(error.response.status).send(error.response.data);
        } else {
          console.error("Generic error in handler.");
          response.status(500).send("Internal Server Error proxying request.");
        }
      }
    });
  }
);

console.log("Function definition finished."); // Log 8: Global scope end
