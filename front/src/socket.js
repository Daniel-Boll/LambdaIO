let connection = new WebSocket("ws://26.117.43.153:3001");

let width = 800;
let height = 600;

let uuid;

let playerState = {
  health: 30,
  velocity: 3,
  score: 0,
  position: {
    x: width / 2,
    y: height / 2,
  },
  uuid,
  shoot: [],
};

let gameState = {
  shoot: [],
  players: [],
};

connection.onopen = (evt) => {
  // --
};

connection.onmessage = (evt) => {
  if (uuid == undefined) {
    uuid = evt.data;
    playerState.uuid = uuid;
  } else {
    // console.log(evt.data);
    gameState = JSON.parse(evt.data);
  }
  // console.log(gameState);
};

const notify = () => {
  connection.send(JSON.stringify(playerState));
};
