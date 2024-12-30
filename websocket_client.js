const ws = new WebSocket('ws://localhost:8080');

ws.onopen = () => {
  console.log('Connected to WebSocket server');
  ws.send('Hello Server!');
};

ws.onmessage = (event) => {
  console.log(`Message from server: ${event.data}`);
};

ws.onclose = () => {
  console.log('Connection closed');
};
