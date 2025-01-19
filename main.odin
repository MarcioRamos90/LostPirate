package main
import "core:fmt"

import rl "vendor:raylib"

Platform :: struct {
    texture: rl.Texture2D,
    position: rl.Vector2,
}

Player :: struct {
    texture: rl.Texture2D,
    position: rl.Vector2,
    velocity: f32
}

Item :: struct {
	texture: rl.Texture2D,
	position: rl.Vector2,
	health: u16,
	active: bool,
	grabbable: bool
}

Iventory :: [20]struct {
	item: Item,
	quantity: u32,
}

PixelwindowHeight :: 180

main :: proc()
{
    screenWidth: i32 = 1280
    screenHeight: i32 = 720

    rl.InitWindow(screenWidth, screenHeight, "Lost Pirate")
    rl.SetWindowState({.WINDOW_RESIZABLE})

    // sland
    sland := Platform{}
    sland.texture = rl.LoadTexture("assets/sland-1.png")
    
    // Iventory
    iventory := Iventory{}

    // Player
    player := Player{}
    player.texture = rl.LoadTexture("assets/player.png")
    player.position = {40, 50}
    player.velocity = 2

    // Tree
    tree := Item{}
    tree.texture = rl.LoadTexture("assets/tree0.png")
    tree.position = rl.Vector2{f32(sland.texture.width/2), f32(sland.texture.height/2)}
    tree.health = 3

    // item-wood-tree0
    wood0 := Item{}
    wood0.texture = rl.LoadTexture("assets/item-wood-tree0.png")
    wood0.position = {0, 0}
    wood0.grabbable = true

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

	// Atack item
	if rl.IsKeyDown(.SPACE)
	{
	    // calculate distance
	    distance := rl.Vector2Distance(player.position, rl.Vector2{tree.position.x, tree.position.y + f32(tree.texture.height / 2)})
	    fmt.println(distance)
	    if distance < f32(50)
	    {
		tree.health -= 1
	    }
	}

	if rl.IsKeyDown(.G)
	{
	    distance := rl.Vector2Distance(player.position, rl.Vector2{wood0.position.x, wood0.position.y})
	    if (wood0.grabbable)
	    {
	         wood0.active = false
		 iventory[0].item = wood0
		 iventory[0].quantity += 1
	    }
            fmt.println(distance)
	}
	
	// check ivnetory
	if rl.IsKeyDown(.I)
	{
            fmt.println(iventory[0])
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

DrawTree :: proc(tree: ^Item, wood0: ^Item) {
    if tree.health <= 3 {
	wood0.position = tree.position
	rl.DrawTextureEx(tree.texture, tree.position, 0, 1, rl.WHITE)
    }
    else
    {
	rl.DrawTextureEx(wood0.texture, wood0.position, 0, 2, rl.WHITE)
    }
}
