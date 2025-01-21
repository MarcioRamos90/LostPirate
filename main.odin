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
    velocity: f32,
}

ItemType :: enum {
    TREE0,
    WOOD0,
}

Item :: struct {
    texture: rl.Texture2D,
    position: rl.Vector2,
    health: u16,
    active: bool,
    grabbable: bool,
    type: ItemType,
}

Iventory :: [20]struct {
    type: ItemType,
    quantity: u32,
}

PixelwindowHeight :: 180

ItemTextures :: struct {
    wood0: rl.Texture2D,
    tree0: rl.Texture2D,
}

get_texture_from_type :: proc(type: ItemType, textures: ItemTextures) -> rl.Texture2D
{
   return textures.wood0
}

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

    // Textures items
    textures := ItemTextures{}
    textures.wood0 = rl.LoadTexture("assets/item-wood-tree0.png")
    textures.tree0 = rl.LoadTexture("assets/tree0.png")

    // Tree
    tree := Item{}
    tree.texture = textures.tree0
    tree.position = rl.Vector2{f32(sland.texture.width/2), f32(sland.texture.height/2)}
    tree.health = 3
    tree.type = .TREE0

    // item-wood-tree0
    wood := Item{}
    wood.texture = textures.wood0
    wood.position = {0, 0}
    wood.grabbable = true
    wood.active = true
    wood.type = .WOOD0

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
	    distance := rl.Vector2Distance(player.position, rl.Vector2{wood.position.x, wood.position.y})
	    if (distance <= f32(50) && wood.type == .WOOD0)
	    {
	         wood.active = false
		 iventory[0].type = .WOOD0
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
		DrawTree(&tree, &wood)
		rl.DrawTextureEx(player.texture, player.position, 0, 1, rl.WHITE)
	    }
	    else
	    {
		rl.DrawTextureEx(player.texture, player.position, 0, 1, rl.WHITE)
		DrawTree(&tree, &wood)
	    }

	    // Show Iventory
	    {
		bar_size : i32 = 320
		rect_size : i32 = 32
		position := player.position
		y_pos := i32(position.y) - (screenHeight/4) + 10
		x_pos := i32(position.x) - (bar_size/2)
		rl.DrawRectangle(x_pos, y_pos, bar_size, 30, rl.RED)
		for i in 0..<10{
		    if iventory[i].quantity > 0 {
			next_x := x_pos + i32(i) * bar_size/10
			texture := get_texture_from_type(iventory[i].type, textures)
			rl.DrawTextureEx(texture, {f32(next_x) - f32(texture.width/2), f32(y_pos) - f32(texture.height/2)}, 0, 2, rl.WHITE)
			text : cstring = "A piece of wood"
			rl.DrawText(text, x_pos, y_pos + 35, 10, rl.BLACK) 
		    }
		}
	    }

	    rl.EndMode2D()

	}	
	rl.EndDrawing()
    }

    rl.CloseWindow()
}

DrawTree :: proc(tree: ^Item, wood: ^Item) {
    if tree.health <= 3 {
	wood.position = tree.position
	rl.DrawTextureEx(tree.texture, tree.position, 0, 1, rl.WHITE)
    }
    else
    {
	if wood.active {
	    rl.DrawTextureEx(wood.texture, wood.position, 0, 2, rl.WHITE)
	}
    }
}
