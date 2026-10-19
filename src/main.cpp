// main.cpp [ENTRY POINT]

#include <raylib.h>
// import game;
// import camera;

// Game window size total is 800px x 900px
constexpr int width{800};
constexpr int game_height{250};
constexpr int camera_height{650};
constexpr int height{game_height + camera_height};


int main() {
    // Rectange {x, y, width, height}
    Rectangle game_rect{0, 0, width, game_height};
    Rectangle camera_rect{0, game_height, width, camera_height};

    InitWindow(width, height, "DinoDash");
    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawRectangleRec(game_rect, LIGHTGRAY);
        DrawRectangleRec(camera_rect, DARKGRAY);

        EndDrawing();
    }

    CloseWindow();
}

