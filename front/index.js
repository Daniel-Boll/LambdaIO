let connection = new WebSocket("ws://127.0.0.1:3001");

connection.onopen = (evt) => {
  let doc = document.getElementById("status");
  doc.innerHTML = "Connected";
  doc.style.color = "#4cd62b";
};

connection.onmessage = (evt) => {
  let myP = document.getElementById("myList");
  myP.innerHTML += evt.data + "<br></br>";
  console.log(evt.data);
};

const send_socket = () => {
  let player = {
    x: 200,
    y: 300,
    score: 0,
  };
  connection.send(JSON.stringify(player));
  // connection.send("" + Math.floor(Math.random() * 10 + 1));
};
