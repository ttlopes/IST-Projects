// Bakeoff #2 - Seleção de Alvos Fora de Alcance
// IPM 2021-22, Período 3
// Entrega: até dia 22 de Abril às 23h59 através do Fenix
// Bake-off: durante os laboratórios da semana de 18 de Abril

// p5.js reference: https://p5js.org/reference/

// Database (CHANGE THESE!)
const GROUP_NUMBER = "21-TP"; // Add your group number here as an integer (e.g., 2, 3)
const BAKE_OFF_DAY = false; // Set to 'true' before sharing during the bake-off day

// Target and grid properties (DO NOT CHANGE!)
let PPI, PPCM;
let TARGET_SIZE;
let TARGET_PADDING, MARGIN, LEFT_PADDING, TOP_PADDING;
let continue_button;
let inputArea = { x: 0, y: 0, h: 0, w: 0 }; // Position and size of the user input area

// Metrics
let testStartTime, testEndTime; // time between the start and end of one attempt (54 trials)
let hits = 0; // number of successful selections
let misses = 0; // number of missed selections (used to calculate accuracy)

// Study control parameters
let draw_targets = false; // used to control what to show in draw()
let trials = []; // contains the order of targets that activate in the test
let current_trial = 0; // the current trial number (indexes into trials array above)
let attempt = 0; // users complete each test twice to account for practice (attemps 0 and 1)
let fitts_IDs = [0]; // add the Fitts ID for each selection here (-1 when there is a miss)

// Target class (position and width)
class Target {
    constructor(x, y, w) {
        this.x = x;
        this.y = y;
        this.w = w;
    }
}

// Gif
let gif;

// Sounds
let hit_sound, miss_sound, music_1, music_2;

// Input
let aimbot_x, aimbot_y;

// Var for the user input area
let on_Target = false;

// Function to preload the files
function preload() {
    gif = createImg("https://i.imgur.com/gwhZZWc.gif", "Gif");
    gif.hide();
    hit_sound = loadSound("hit.mp3");
    miss_sound = loadSound("miss.mp3");
    music_1 = loadSound("music_1.mp3");
    const soundtrack = int(random(0, 3));
    if (soundtrack == 0) {
        music_2 = loadSound("garagem.mp3");
    } else if (soundtrack == 1) {
        music_2 = loadSound("cabritinha.mp3");
    } else {
        music_2 = loadSound("casar.mp3");
    }
}

// Runs once at the start
function setup() {
    createCanvas(700, 500); // window size in px before we go into fullScreen()
    frameRate(60); // frame rate (DO NOT CHANGE!)

    randomizeTrials(); // randomize the trial order at the start of execution

    textFont("Arial", 18); // font size for the majority of the text
    drawUserIDScreen(); // draws the user start-up screen (student ID and display size)
    hit_sound.setVolume(0.2);
    miss_sound.setVolume(0.2);
}

// Runs every frame and redraws the screen
function draw() {
    if (draw_targets) {
        // The user is interacting with the 6x3 target grid
        background(color(0, 0, 0)); // sets background to black

        // Print trial count at the top left-corner of the canvas
        fill(color(255, 255, 255));
        textAlign(LEFT);
        text("Trial " + (current_trial + 1) + " of " + trials.length, 50, 20);

        // Draw the user input area
        drawInputArea();

        // Draw line
        drawLine();

        let x = map(mouseX, inputArea.x, inputArea.x + inputArea.w, 0, width);
        let y = map(mouseY, inputArea.y, inputArea.y + inputArea.h, 0, height);

        let closest_target = getClosestTarget(x, y);

        aimbot_x = closest_target.x;
        aimbot_y = closest_target.y;

        // Draw all 18 targets
        for (var i = 0; i < 18; i++) {
            drawTarget(i, aimbot_x, aimbot_y);
        }

        drawInstructions();

        gif.size(1.5 * PPCM, 1.5 * PPCM);
        gif.position(aimbot_x - 0.75 * PPCM, aimbot_y - 0.75 * PPCM);
        gif.show();

        noStroke();
    }
}

// Responsible for drawing the input area
function drawInputArea() {
    noFill();
    stroke(color(220, 220, 220));
    if (on_Target) {
        stroke(color(255, 255, 0));
        drawingContext.shadowColor = color(255, 255, 0);
        drawingContext.shadowBlur = 10;
    }

    strokeWeight(2);
    rect(inputArea.x, inputArea.y, inputArea.w, inputArea.h);
    drawingContext.shadowBlur = 0;
    on_Target = false;
}

// Get the closest target to the aimbot cursor
function getClosestTarget(x, y) {
    let target = 0,
        distance = dist(x, y, getTargetBounds(0).x, getTargetBounds(0).y),
        temp = 0;

    for (var i = 1; i < 18; i++) {
        temp = dist(x, y, getTargetBounds(i).x, getTargetBounds(i).y);
        if (temp < distance) {
            distance = temp;
            target = i;
        }
    }
    return getTargetBounds(target);
}

// Draws line between the current target and next target
function drawLine() {
    const current = getTargetBounds(trials[current_trial]);
    stroke(color(100, 100, 100));
    strokeWeight(4);
    if (trials[current_trial + 1]) {
        const next = getTargetBounds(trials[current_trial + 1]);
        line(current.x, current.y, next.x, next.y);
    }

    if (trials[current_trial - 1]) {
        const prev = getTargetBounds(trials[current_trial - 1]);
        line(current.x, current.y, prev.x, prev.y);
    }
}

// Draws the instructions for the user and misses counter
function drawInstructions() {
    // Draw instructions above input area
    let pos_X = inputArea.y - TARGET_SIZE * 1.5;

    // Label for Target
    fill(color(0, 255, 0));
    noStroke();
    circle(inputArea.x + TARGET_SIZE * 0.5, pos_X, TARGET_SIZE);
    fill(color(255, 255, 255));
    text("Target", inputArea.x + TARGET_SIZE * 1.7, pos_X);

    // Label for Next Target
    fill(color(255, 0, 0));
    noStroke();
    circle(
        inputArea.x + inputArea.w / 2 + TARGET_SIZE * 0.5,
        pos_X,
        TARGET_SIZE
    );
    fill(color(255, 255, 255));
    text(
        "Next Target",
        inputArea.x + inputArea.w / 2 + TARGET_SIZE * 1.7,
        pos_X
    );
    pos_X -= TARGET_SIZE * 1.5;

    // Label for Double Target
    fill(color(0, 255, 0));
    stroke(color(255, 0, 0));
    strokeWeight(10);
    circle(inputArea.x + TARGET_SIZE * 0.5, pos_X, TARGET_SIZE);
    fill(color(255, 255, 255));
    noStroke();
    text("Click Twice", inputArea.x + TARGET_SIZE * 1.7, pos_X);
    text(
        "When the Input area is yellow, its within the target area.",
        inputArea.x,
        inputArea.y - 15
    );

    // Misses Label
    textSize(40);
    text("Misses: " + misses, inputArea.x, inputArea.y + inputArea.h + 50);

    // Tip Label
    textSize(18);
    text(
        "Tip: look only to the input area",
        inputArea.x,
        inputArea.y + inputArea.h + 85
    );
}

// Print and save results at the end of 54 trials
function printAndSavePerformance() {
    // DO NOT CHANGE THESE!
    let accuracy = parseFloat(hits * 100) / parseFloat(hits + misses);
    let test_time = (testEndTime - testStartTime) / 1000;
    let time_per_target = nf(test_time / parseFloat(hits + misses), 0, 3);
    let penalty = constrain(
        (parseFloat(95) - parseFloat(hits * 100) / parseFloat(hits + misses)) *
            0.2,
        0,
        100
    );
    let target_w_penalty = nf(
        test_time / parseFloat(hits + misses) + penalty,
        0,
        3
    );
    let timestamp =
        day() +
        "/" +
        month() +
        "/" +
        year() +
        "  " +
        hour() +
        ":" +
        minute() +
        ":" +
        second();

    background(color(0, 0, 0)); // clears screen
    fill(color(255, 255, 255)); // set text fill color to white
    text(timestamp, 10, 20); // display time on screen (top-left corner)

    textAlign(CENTER);
    text("Attempt " + (attempt + 1) + " out of 2 completed!", width / 2, 60);
    text("Hits: " + hits, width / 2, 100);
    text("Misses: " + misses, width / 2, 120);
    text("Accuracy: " + accuracy + "%", width / 2, 140);
    text("Total time taken: " + test_time + "s", width / 2, 160);
    text("Average time per target: " + time_per_target + "s", width / 2, 180);
    text(
        "Average time for each target (+ penalty): " + target_w_penalty + "s",
        width / 2,
        220
    );

    // Print Fitts IDS (one per target, -1 if failed selection, optional)
    text("Fitts Index of Performance", width / 2, 260);

    for (let i = 0; i < trials.length; i++) {
        let label;
        pos_X = i < trials.length / 2 ? width / 3 : (2 * width) / 3;
        pos_Y = 280 + 20 * (i % (trials.length / 2));

        if (i == 0) {
            label = "---";
        } else if (fitts_IDs[i] == -1) {
            label = "MISSED";
        } else {
            label = round(fitts_IDs[i], 3);
        }
        text("Target " + (i + 1) + ": " + label, pos_X, pos_Y);
    }

    // Saves results (DO NOT CHANGE!)
    let attempt_data = {
        project_from: GROUP_NUMBER,
        assessed_by: student_ID,
        test_completed_by: timestamp,
        attempt: attempt,
        hits: hits,
        misses: misses,
        accuracy: accuracy,
        attempt_duration: test_time,
        time_per_target: time_per_target,
        target_w_penalty: target_w_penalty,
        fitts_IDs: fitts_IDs,
    };

}

// Mouse button was pressed - lets test to see if hit was in the correct target
function mousePressed() {
    // Only look for mouse releases during the actual test
    // (i.e., during target selections)
    if (draw_targets) {
        // Get the location and size of the target the user should be trying to select
        let target = getTargetBounds(trials[current_trial]);

        // increasing either the 'hits' or 'misses' counters
        if (insideInputArea(mouseX, mouseY)) {
            if (dist(target.x, target.y, aimbot_x, aimbot_y) < target.w / 2) {
                hits++;
                hit_sound.play();
            } else {
                misses++;
                miss_sound.play();
                // Set Fitts ID to -1 if the user misses
                fitts_IDs.pop();
                fitts_IDs.push(-1);
            }
            if (current_trial < trials.length - 1) {
                fitts_IDs.push(fitts_next_calculator());
            }
            current_trial++; // Move on to the next trial/target
        }

        // Check if the user has completed all 54 trials
        if (current_trial === trials.length) {
            gif.hide();
            testEndTime = millis();
            draw_targets = false; // Stop showing targets and the user performance results
            printAndSavePerformance(); // Print the user's results o n-screen and send these to the DB
            attempt++;

            // If there's an attempt to go create a button to start this
            if (attempt < 2) {
                music_1.play();
                continue_button = createButton("START 2ND ATTEMPT");
                continue_button.mouseReleased(continueTest);
                continue_button.position(
                    width / 2 - continue_button.size().width / 2,
                    height / 2 - continue_button.size().height / 2
                );
            } else {
                music_2.play();
            }
        }
        // Check if this was the first selection in an attempt
        else if (current_trial === 1) {
            testStartTime = millis();
        }
    }
}

function fitts_next_calculator() {
    const target = getTargetBounds(trials[current_trial] + 1);
    return Math.log2(
        dist(aimbot_x, aimbot_y, target.x, target.y) / target.w + 1
    );
}

function drawTarget(i, x, y) {
    // Get the location and size for target (i)
    const target = getTargetBounds(i);

    const x_target = map(
        target.x,
        0,
        width,
        inputArea.x,
        inputArea.x + inputArea.w
    );
    const y_target = map(
        target.y,
        0,
        height,
        inputArea.y,
        inputArea.y + inputArea.h
    );

    rectMode(CENTER);
    noStroke();

    // Current Target and Next Target are equal
    if (trials[current_trial] === i && trials[current_trial + 1] === i) {
        // Red Circle and Red Square
        fill(255, 0, 0);
        circle(target.x, target.y, target.w);
        square(x_target, y_target, target.w * (inputArea.w / height));

        // Green Circle and Green Square
        fill(0, 255, 0);
        // If cursor over target, change color to yellow and input area turns yellow
        if (dist(target.x, target.y, x, y) < target.w / 2) {
            fill(255, 255, 0);
            on_Target = true;
        }
        circle(target.x, target.y, target.w - 0.5 * PPCM);
        square(x_target, y_target, target.w - PPCM);
    }
    // Current Target
    else if (trials[current_trial] === i) {
        // Green Circle and Green Square
        fill(0, 255, 0);
        // If cursor over target, change color to yellow and input area turns yellow
        if (dist(target.x, target.y, x, y) < target.w / 2) {
            fill(255, 255, 0);
            on_Target = true;
        }
        circle(target.x, target.y, target.w);
        square(x_target, y_target, target.w * (inputArea.w / height));
    }
    // Next Target
    else if (trials[current_trial + 1] === i) {
        fill(255, 0, 0);
        circle(target.x, target.y, target.w);
        square(x_target, y_target, target.w * (inputArea.w / height));
    }
    // Rest
    else {
        fill(100, 100, 100);
        circle(target.x, target.y, target.w);
        square(x_target, y_target, target.w * (inputArea.w / height));
    }
    // Reset drawing mode
    rectMode(CORNER);
}

// Returns the location and size of a given target
function getTargetBounds(i) {
    var x =
        parseInt(LEFT_PADDING) +
        parseInt((i % 3) * (TARGET_SIZE + TARGET_PADDING) + MARGIN);
    var y =
        parseInt(TOP_PADDING) +
        parseInt(Math.floor(i / 3) * (TARGET_SIZE + TARGET_PADDING) + MARGIN);

    return new Target(x, y, TARGET_SIZE);
}

// Evoked after the user starts its second (and last) attempt
function continueTest() {
    // Re-randomize the trial order
    shuffle(trials, true);
    current_trial = 0;
    print("trial order: " + trials);

    // Resets performance variables
    hits = 0;
    misses = 0;
    fitts_IDs = [0];

    continue_button.remove();

    // Shows the targets again
    draw_targets = true;
    testStartTime = millis();

    music_1.stop();
}

// Is invoked when the canvas is resized (e.g., when we go fullscreen)
function windowResized() {
    resizeCanvas(windowWidth, windowHeight);

    let display = new Display({ diagonal: display_size }, window.screen);

    // DO NOT CHANGE THESE!
    PPI = display.ppi; // calculates pixels per inch
    PPCM = PPI / 2.54; // calculates pixels per cm
    TARGET_SIZE = 1.5 * PPCM; // sets the target size in cm, i.e, 1.5cm
    TARGET_PADDING = 1.5 * PPCM; // sets the padding around the targets in cm
    MARGIN = 1.5 * PPCM; // sets the margin around the targets in cm

    // Sets the margin of the grid of targets to the left of the canvas (DO NOT CHANGE!)
    LEFT_PADDING =
        width / 3 - TARGET_SIZE - 1.5 * TARGET_PADDING - 1.5 * MARGIN;

    // Sets the margin of the grid of targets to the top of the canvas (DO NOT CHANGE!)
    TOP_PADDING =
        height / 2 - TARGET_SIZE - 3.5 * TARGET_PADDING - 1.5 * MARGIN;

    // Defines the user input area (DO NOT CHANGE!)
    inputArea = {
        x: width / 2 + 2 * TARGET_SIZE,
        y: height / 2,
        w: width / 3,
        h: height / 3,
    };

    // Starts drawing targets immediately after we go fullscreen
    draw_targets = true;
}
