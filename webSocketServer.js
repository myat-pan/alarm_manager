

const WebSocket = require("ws");

const wss = new WebSocket.Server({ port: 5556 });

wss.on("connection", ws => {
  ws.on("message", message => {
    ws.send("Echo message sent back from server: " + message);
  });
  ws.send("Hello! Message from server. You've just connected to the server!!");
});