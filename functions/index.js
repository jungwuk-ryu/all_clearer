/**
 * Import function triggers from their respective submodules:
 *
 * const { onCall } = require("firebase-functions/v2/https");
 * const { onDocumentWritten } = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

exports.getServerTime = onRequest({
    region: "asia-northeast3",
  }, async (request, response) => {
    response.set("Access-Control-Allow-Origin", "*"); // 모든 도메인 허용
    response.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.set("Access-Control-Allow-Headers", "Content-Type");

  try {
    // ?url=... 형태로 전달된 파라미터 가져오기
    const url = request.query.url;
    if (!url) {
      response.status(400).send("잘못된 쿼리입니다.");
      return;
    }

    // URL로 GET 요청
    const res = await fetch(url);
    if (!res.ok) {
      response.status(res.status).send(`Failed to fetch: ${res.statusText}`);
      return;
    }

    // response header에서 date 헤더 추출
    const serverTime = res.headers.get("date");
    if (!serverTime) {
      response.status(404).send("HTTP 응답 헤더에서 date 값을 찾지 못함.");
      return;
    }

    // date 헤더를 JSON 형태로 응답
    response.send({ serverTime });
  } catch (error) {
    logger.error(error);
    response.status(500).send(error.toString());
  }
});
