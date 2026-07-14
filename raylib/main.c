#include "raylib.h"

int main(void)
{
    const int screenWidth = 800;
    const int screenHeight = 450;
    const float squareSize = 50.0;
    const float speed = 250.0;
    Vector2 squarePosition = {
        (screenWidth - squareSize) / 2.0,
        (screenHeight - squareSize) / 2.0
    };

    InitWindow(screenWidth, screenHeight, "Move the red square");
    SetTargetFPS(60);

    while (!WindowShouldClose())
    {
        const float distance = speed * GetFrameTime();

        if (IsKeyDown(KEY_RIGHT)) squarePosition.x += distance;
        if (IsKeyDown(KEY_LEFT)) squarePosition.x -= distance;
        if (IsKeyDown(KEY_DOWN)) squarePosition.y += distance;
        if (IsKeyDown(KEY_UP)) squarePosition.y -= distance;

        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawRectangle(squarePosition.x, squarePosition.y, squareSize, squareSize, RED);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
