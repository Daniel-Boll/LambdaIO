let connection = new WebSocket("ws://127.0.0.1:3001");

let uuid;

connection.onopen = (evt) => {
  let doc = document.getElementById("status");
  doc.innerHTML = "Connected";
  doc.style.color = "#4cd62b";
};

connection.onmessage = (evt) => {
  let myP = document.getElementById("myList");
  myP.innerHTML = "<br></br>" + evt.data;
  if (uuid == undefined) uuid = evt.data;
};

const send_socket = () => {
  let player = {
    uuid: uuid,
    x: 200,
    y: 300,
    health: 100,
    score: 0,
    actions: {
      damage: 1,
      shot: [[1, 2, 3, 4]],
    },
  };

  console.log(player);
  connection.send(JSON.stringify(player));
};
