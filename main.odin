package main
import "core:fmt"

import rl "vendor:raylib"

platform :: struct {
    texture: rl.Texture2D,
    position: rl.Vector2,
}

Player :: struct {
    texture: rl.Texture2D,
    position: rl.Vector2,
    velocity: f32
}

item :: struct {
    texture: rl.Texture2D,
    position: rl.Vector2,
    health: u16,
}

PixelwindowHeight :: 180

main :: proc()
{
    screenWidth: i32 = 1280
    screenHeight: i32 = 720

    rl.InitWindow(screenWidth, screenHeight, "Lost Pirate")
    rl.SetWindowState({.WINDOW_RESIZABLE})

    // sland
    sland := platform{}
    sland.texture = rl.LoadTexture("assets/sland-1.png")
    
    // Player
    player := Player{}
    player.texture = rl.LoadTexture("assets/player.png")
    player.position = {40, 50}
    player.velocity = 2


    // Tree
    tree := item{}
    tree.texture = rl.LoadTexture("assets/tree0.png")
    tree.position = {f32(sland.texture.width/2), f32(sland.texture.height/2)}
    tree.health = 3

    // item-wood-tree0
    wood0 := item{}
    wood0.texture = rl.LoadTexture("assets/item-wood-tree0.png")
    wood0.position = {0, 0}

    rl.SetTargetFPS(100)

    for !rl.WindowShouldClose() 
    {
	if rl.IsKeyDown(rl.KeyboardKey.DOWN)
	{
	    player.position.y += player.velocity
	}
	else if rl.IsKeyDown(.UP)
	{
	    player.position.y -= player.velocity
	}
	else if rl.IsKeyDown(.LEFT)
	{
	    player.position.x -= player.velocity
	}
	else if rl.IsKeyDown(.RIGHT)
	{
	    player.position.x += player.velocity
	}

	// Atack
	if rl.IsKeyDown(.SPACE)
	{
	    // calculate distance
	    distance := rl.Vector2Distance(player.position, tree.position)
	    fmt.println(distance)
	    if distance < f32(3)
	    {
		tree.health -= 1
	    }
	}
	
	camera := rl.Camera2D {
	    offset = {f32(rl.GetScreenWidth() / 2), f32(rl.GetScreenHeight() / 2)},
	    target = player.position,
	    zoom   = f32(screenHeight / PixelwindowHeight) * f32(0.5),
	}
		
	rl.BeginDrawing()
	{
	    rl.BeginMode2D(camera)

	    rl.ClearBackground(rl.BLUE)

	    rl.DrawTextureEx(sland.texture, sland.position, 0, 1, rl.WHITE)
	    
	    if tree.position.y + f32(tree.texture.height/2) < player.position.y
	    {
		DrawTree(&tree, &wood0)
		rl.DrawTextureEx(player.texture, player.position, 0, 1, rl.WHITE)
	    }
	    else
	    {
		rl.DrawTextureEx(player.texture, player.position, 0, 1, rl.WHITE)
		DrawTree(&tree, &wood0)
	    }
	    rl.EndMode2D()

	}	
	rl.EndDrawing()
    }

    rl.CloseWindow()
}

DrawTree :: proc(tree: ^item, wood0: ^item) {
    if tree.health <= 3 {
	wood0.position = tree.position
	rl.DrawTextureEx(tree.texture, tree.position, 0, 1, rl.WHITE)
    }
    else
    {
	rl.DrawTextureEx(wood0.texture, wood0.position, 0, 2, rl.WHITE)
    }
}
