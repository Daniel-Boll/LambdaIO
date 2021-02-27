let lastShot = Date.now();

function setup() {
  createCanvas(width, height);
}

function draw() {
  background(231);

  fill(255, 0, 0);
  rect(playerState.position.x, playerState.position.y, 10, 10);
  drawOtherPlayers();

  fill(255);

  movement();

  // if (Date.now() >= lastShot) shoot();

  // drawShoot();
  top.playerState = playerState;
}

const drawOtherPlayers = () => {
  if (gameState.players) {
    for (player of gameState.players) {
      if (player.uuid != uuid) {
        fill(80, 80, 80);
        rect(player.position.x, player.position.y, 10, 10);
      }
    }
  }
};

const drawShoot = () => {
  // TODO: Atirar fora do player
  if (playerState.shoot) {
    for (index in playerState.shoot) {
      let vector = playerState.shoot[index].vector;
      let bullet = {
        origin: createVector(vector[0], vector[1]),
        velocity: createVector(vector[2], vector[3]),
      };

      bullet.origin = bullet.origin.add(bullet.velocity);

      ellipse(bullet.origin.x, bullet.origin.y, 10, 10);

      const leftWall = bullet.origin.x <= 0;
      const rightWall = bullet.origin.x >= width;
      const bottomWall = bullet.origin.y >= height;
      const upperWall = bullet.origin.y <= 0;

      if (leftWall || rightWall || bottomWall || upperWall) {
        playerState.shoot.splice(index, 1);
        // destroy shot
      } else {
        playerState.shoot[index].vector = [
          bullet.origin.x,
          bullet.origin.y,
          bullet.velocity.x,
          bullet.velocity.y,
        ];
      }
    }
  }
};

const generateHash = () =>
  Math.random().toString(36).substring(2, 15) +
  Math.random().toString(36).substring(2, 15);

const shoot = () => {
  if (mouseIsPressed) {
    let toX = mouseX - playerState.position.x;
    let toY = mouseY - playerState.position.y;

    let velocity = createVector(toX, toY);
    velocity.normalize();
    velocity.mult(5);

    let origin = createVector(playerState.position.x, playerState.position.y);
    origin.mag(velocity * 10);

    playerState.shoot.push({
      sid: generateHash(),
      vector: [origin.x, origin.y, velocity.x, velocity.y],
    });

    lastShot = Date.now() + 500;
  }
};

const movement = () => {
  if (keyIsDown(LEFT_ARROW) || keyIsDown(65)) {
    notify();
    playerState.position.x -= playerState.velocity;
  }

  if (keyIsDown(RIGHT_ARROW) || keyIsDown(68)) {
    notify();
    playerState.position.x += playerState.velocity;
  }

  if (keyIsDown(UP_ARROW) || keyIsDown(87)) {
    notify();
    playerState.position.y -= playerState.velocity;
  }

  if (keyIsDown(DOWN_ARROW) || keyIsDown(83)) {
    notify();
    playerState.position.y += playerState.velocity;
  }

  playerState.position.x = constrain(playerState.position.x, 0, width - 10);
  playerState.position.y = constrain(playerState.position.y, 0, height - 10);
};

const getSocketInfo = (socketInfo) => {
  console.log(socketInfo);
};
