//h
INPUT_GRAPPLE = keyboard_check_pressed(ord("G"))

if(place_meeting(x, y, obj_wall))
    y--

if(!on_ground)
{
    duck = 0
}
spd = 2;
if(duck)
{
    spd = 1
    if(abs(hsp) > 1)
        hsp = approach(hsp, 1 * input_dir, 0.25)
}

if(on_ground)
{
    accel = ground_accel;
    fric = ground_fric;
}
else
{
    accel = air_accel;
    fric = air_fric;
}
switch(state)
{
    case "donothing":
    {
        break
    }
    case "normal": default:
    {
        can_attack = 1;
        can_jump = 1;
        if (duck > 1)
            mask_index = mask_anime_duck
        else
            mask_index = mask_anime
        if (INPUT_MOVE == 1)
        {
            if (hsp < 0)
            {
                hsp = approach(hsp, 0, fric)
            }
            else if (on_ground && vsp >= 0)
            {
                if (duck == 0 && !landTimer)
                    sprite_index = spr_anime_run
                else if(duck)
                    sprite_index = spr_anime_crawl
            }
            if run
                run = 7
            if (hsp < spd)
                hsp = approach(hsp, spd, accel)
            if on_ground
                facing = 1
            else
                facing = approach(facing, 1, 0.2)
        }
        else if (INPUT_MOVE == -1)
        {
            if (hsp > 0)
            {
                hsp = approach(hsp, 0, fric)
            }
            else if (on_ground && vsp >= 0)
            {
                if (duck == 0 && !landTimer)
                    sprite_index = spr_anime_run
                else if(duck)
                    sprite_index = spr_anime_crawl
            }
            if run
                run = 7
            if (hsp > -spd)
                hsp = approach(hsp, -spd, accel)
            if on_ground
                facing = -1
            else
                facing = approach(facing, -1, 0.2)
        }
        else
        {
            hsp = approach(hsp, 0, (fric * 2))
            if (abs(hsp) < 2)
            {
                if run
                    run--
            }
            if (abs(hsp) < 0.5 && on_ground && (!landTimer))
            {
                sprite_index = spr_anime
                image_index += 0.2;
                if duck
                {
                    sprite_index = spr_anime_duck
                    image_index = duck
                    lookup = -0.5;
                }
                else if (INPUT_LOOKUP)
                {
                    sprite_index = spr_player_lookup
                    lookup = 1;
                }
                else
                {
                    lookup = 0;
                }
            }
        }
        if (INPUT_DUCK && on_ground)
            duck = approach(duck, 3, 1)
        else if (!place_meeting(x, y - 8, obj_wall))
            duck = approach(duck, 0, 1)
        if (!on_ground)
        {
            lookup = 0

            if (vsp >= -0.5)
            {
                if place_meeting(x + (2 * INPUT_MOVE), y, obj_wall)
                    state = "wallslide"
            }
            sprite_index = spr_anime_jump
            if (vsp >= 0.1)
                vsp = approach(vsp, vsp_max, grv)
            if (vsp < 0)
                vsp = approach(vsp, vsp_max, grv)
            else if (vsp < 2)
                vsp = approach(vsp, vsp_max, (grv * 0.25))
            if (vsp < 0)
                image_index = approach(image_index, 1, 0.2)
            else if (vsp >= 0.5)
                image_index = approach(image_index, 5, 0.5)
            else
                image_index = 3
        }
        else
            wallslideTimer = 0
        if (sprite_index == spr_anime_run)
            image_index += (hsp / 6)
        else if (duck)
            image_index += abs(hsp / 4)
        landTimer = approach(landTimer, 0, 1)
        break;
    }
    case "wallslide":
    {
        if (vsp < 0)
            vsp = approach(vsp, vsp_max, 0.5);
        else
            vsp = approach(vsp, vsp_max / 3, grv / 3);
        if (!(place_meeting(x + (INPUT_MOVE * 2), y, obj_wall)))
        {
            state = "normal";
            wallslideTimer = 0;
        }
        sprite_index = spr_anime_wallslide;
        var n = choose(0, 1, 0);
        if n
            with (instance_create_depth(x + 4 * sign(facing), random_range(bbox_bottom - 12, bbox_bottom), depth - 1, fx_dust))
            {
                vz = 0;
                sprite_index = spr_fx_dust2
            }
        if (INPUT_MOVE == 0 || on_ground)
        {
            state = "normal";
            wallslideTimer = 0;
        }
        if (sign(INPUT_MOVE) == -sign(facing))
        {
            state = "normal";
            wallslideTimer = 0;
            facing = sign(INPUT_MOVE);
        }
        vsp = clamp(vsp, -99, 2);
        break;
    }
    case "backflip_start":
    {
        if(timer0 == 0)
        {
            can_dodge = 0;
            image_index = 0;
            sprite_index = spr_anime_backflip_a;
            hsp = 0;
            vsp = 0;
            timer0 = 1;
        }
        if(timer0 == 1)
        {
            if(image_index < 2) image_index += 0.25;
            else
            {
                timer0 = 0;
                state = "backflip";
            }
        }
        break;
    }
    case "backflip":
    {
        INPUT_DODGE = 0
        INPUT_JUMP = 0
        can_jump = 0
        if(timer0 == 0)
        {
            can_dodge = 0;
            image_index = 0;
            sprite_index = spr_anime_backflip_b;
            hsp = 0;
            vsp = 0;
            vsp = -2;
            hsp = (-2 * sign(facing));
            invuln = 20;
            timer0++;
            audio_play_sound(sn_flip, 0, false);
        }
        image_index += 0.25;
        vsp = approach(vsp, vsp_max, grv);
        break;
    }
    case "backflip_end":
    {
        if(image_index < 3) image_index += 0.375;
        else
        {
            timer0 = 0;
            image_index = 0;
            state = "hard_land";
        }
    }
    case "hard_land":
    {
        timer0++;
        hsp = approach(hsp, 0, 0.2);
        if (timer0 >= 8 || (!on_ground))
        {
            timer0 = 0;
            can_dodge = 1;
            if(encounter1)
            {
                with(gm)
                {
                    audio_sound_gain(current_bgm, 1, 1000);
                }
                with(oCamera)
                {
                    usefollow = 1;
                    draw_ui = true;
                    zoom = 1;
                }
                global.cutscene = false;
                instance_destroy();
            }
            else state = "normal";
            if(single_wall)
            {
                single_wall = 0;
                INPUT_MOVE = -INPUT_MOVE;
                if place_meeting(x + 2, y, obj_wall)
                {
                    hsp = -2
                    vsp = -2.5
                    facing = -1
                    INPUT_MOVE = -1;
                    audio_play_sound(sn_throw, 0, false)
                }
                if place_meeting(x - 2, y, obj_wall)
                {
                    hsp = 2
                    vsp = -2.5
                    facing = 1
                    INPUT_MOVE = 1;
                    audio_play_sound(sn_throw, 0, false)
                }
            }
        }
        if(instance_exists(obj_player_dead))
        {
            MakeExplosion(x, y);
            scr_particle_explode();
        }
        break;
    }
    case "dinder":
    {
        INPUT_MOVE = 0
        INPUT_JUMP = 0
        INPUT_DODGE = 0
        can_attack = 0;
        can_jump = 0;
        can_dodge = 0;
        if(timer0 == 0)
        {
            image_index = 0;
            sprite_index = spr_anime_dinder;
            hsp = 0;
            vsp = approach(vsp, vsp_max, grv);
            timer0 = 1;
            audio_play_sound(snGroundHit, 0, false);
        }
        if(timer0 <= 40)
        {
            timer0++;
        }
        else
        {
            timer0 = 0;
            image_index = 0;
            sprite_index = spr_anime;
            can_attack = 1;
            can_jump = 1;
            can_dodge = 1;
            state = "normal";
            if(instance_exists(obj_player_dead))
            {
                timer0 = 0;
                image_index = 0;
                flip_counter = 0;
                state = "backflip_start";
            }
        }
        break;
    }
    case "encounter1":
    {
        obj_player.sprite_index = spr_player
        obj_player.hsp = 0
        INPUT_MOVE = 0
        INPUT_JUMP = 0
        INPUT_DODGE = 0
        if(timer0 == 0)
        {
            audio_play_sound(sn_impact, 0, false);
            with(gm) audio_sound_gain(current_bgm, 0, 500);
            with(oCamera)
            {
                usefollow = 0;
                draw_ui = false;
                xTo = 128;
                yTo = 80;
            }
            with(obj_player)
            {
                facing = 1
            }
        }
        if(timer0 < 60)
        {
            timer0++;
            global.cutscene = true;
        }
        if(timer0 == 30)
        {
            audio_play_sound(sn_alert, 0, false);
            facing = -facing;
            with(oCamera)
            {
                zoom = 2;
                xTo = 144;
                yTo = 80;
            }
            with(obj_player)
            {
                x = 136;
            }
        }
        if(timer0 == 60)
        {
            timer0 = 0;
            state = "backflip_start";
        }
        break;
    }
    case "grapple":
    {
        INPUT_MOVE = 0
        INPUT_JUMP = 0
        INPUT_DODGE = 0
        can_jump = 0
        can_dodge = 0
        if(timer0 == 0)
        {
            sprite_index = spr_anime_run
            image_index = 5
            timer0++
            gx = x
            gy = y
            vsp = 0
            hsp = 0

            var _wall = instance_place(gtx, gty, obj_wall)
            if(_wall)
            {
                if(gtx > x)
                    gtx = _wall.bbox_left
                else
                    gtx = _wall.bbox_right
            }
        }
        if(timer0 == 1)
        {
            gx = approach(gx, gtx, 12)
            if(gx == gtx)
            {
                timer0 = 2
                image_index = 6
            }
        }
        if(timer0 >= 2 && timer0 < 10)
        {
            timer0++
        }
        if(timer0 == 10)
        {
            x = approach(x, gtx, 14)
            if(x == gtx)
            {
                x -= 6 * facing
                timer0 = 11
            }
        }
        if(timer0 > 10 && timer0 < 15)
        {
            timer0++
        }
        if(timer0 == 15)
        {
            state = "normal"
        }
        break
    }
}

invuln = max(0, invuln - 1);

check = function(_x, _y)
{
    return (place_meeting(_x, _y, obj_wall) || place_meeting(_x, _y, obj_platform));
}

if(active) && (instance_exists(_target))
{
    var chance = irandom_range(1, 120);

    if(on_ground)
    {
        //jump over gaps
        if(!check(x + (sign(facing) * 16), y + 8)) && (y > target.y - 16) && (can_jump)
        {
            can_jump = 0
            INPUT_JUMP = 1
            chance = -1
        }

        //jump onto platforms
        if(place_meeting(x, y - 24, obj_platform)) && (y > target.y - 4) && (can_jump)
        {
            can_jump = 0
            INPUT_JUMP = 1
            hsp *= 0.7
        }

        //drop through platforms
        if(place_meeting(x, y + 1, obj_platform)) && (!place_meeting(x, y + 1, obj_wall))
        {
            if(y < (target.y - 8))
            {
                INPUT_DUCK = 1
                if(INPUT_DUCK && duck == 3)
                {
                    INPUT_JUMP = 1
                }
            }
            else INPUT_DUCK = 0
        }

        //initiate walljump chains if too low from player
        // if(y - target.y > 80) && (place_meeting(x + sign(facing) * 8, y, obj_wall)) && (can_jump)
        // {
        //     can_jump = 0
        //     INPUT_JUMP = 1
        // }

        //jump over ledges
        if collision_rectangle(x + sign(facing) * 8, y - 40, x + sign(facing), y + 5, obj_wall, false, true) && !place_meeting(x, y - 40, obj_wall) && can_jump && (y > target.y)
        {
            can_jump = 0
            INPUT_JUMP = 1
        }
    }

    //walljumps only if below player and there's adequate space above and below
    else if(!check(x, y + 32)) && (!place_meeting(x, y - 16, obj_wall)) && ((y >= target.y) || (y > room_height))
    {
        chance = -1

        // // single wall walljump via dodging into wall
        // if(!place_meeting(x + 2 * sign(facing), y, obj_wall)) && (cast_check(x, y, -2 * sign(facing), 0, obj_wall, 24)) && (state == "normal") && (can_dodge) && (vsp >= 0.1)
        // {
        //     single_wall = 1;
        //     can_dodge = 0;
        //     timer0 = 0;
        //     state = "backflip_start";
        //     chance = -1;
        // }
    }

    if !on_ground
    {
        if place_meeting(x + 2, y, obj_wall)
        {
            chance = -1
            facing = 1
            INPUT_MOVE = 1
        }
        if place_meeting(x - 2, y, obj_wall)
        {
            chance = -1
            facing = -1
            INPUT_MOVE = -1
        }

        if state == "wallslide"
        {
            if chance == -1
            {
                if TIMER_WALLJUMP >= 5
                {
                    TIMER_WALLJUMP = 0
                    INPUT_JUMP = 1
                }
                TIMER_WALLJUMP++
            }
            else
            {
                if TIMER_WALLJUMP >= 20
                {
                    TIMER_WALLJUMP = 0
                    var h = irandom(1)
                    if h
                    {
                        INPUT_JUMP = 1
                    }
                }
                TIMER_WALLJUMP++
            }
        }
        else TIMER_WALLJUMP = 0
    }

    //charge towards player without random stopping if offscreen
    if(abs(x - target.x) > 128)
    {
        if(chance) INPUT_MOVE = sign(target.x - x);
        chance = -1;
    }

    //adjust speed to aim at player during freefall while above
    if(target.y - y > 64) && (abs(x - target.x) < 16) && (!on_ground)
    {
        hsp = approach(hsp, 0, air_accel);
    }

    if(INPUT_JUMP)
    {
        INPUT_JUMP = 0
        if(on_ground)
        {
            if(!duck)
            {
                state = "normal"
                image_index = 0
                sprite_index = spr_anime_jump
                var c = collision_point(x, (y + 2), obj_moving_platform, 1, 1)
                if c
                {
                    hsp += c.hsp
                    if(c.vsp < 0)
                        vsp = c.vsp
                }
                vsp += jumpsp
                audio_play_sound(sn_jump, 0, false)
            }
            else if(place_meeting(x, (y + 2), obj_platform)) && (INPUT_DUCK)
            {
                sprite_index = spr_anime_jump
                y += 2
                image_index = 2
                platformTarget = noone
            }
            else
            {
                c = collision_point(x, (y + 2), obj_moving_platform, 1, 1)
                if c
                {
                    hsp += c.hsp
                    if(c.vsp < 0)
                        vsp = c.vsp
                }
                vsp += jumpsp / 2
                audio_play_sound(sn_jump, 0, false)
            }
        }
        else
        {
            if place_meeting(x + 2, y, obj_wall)
            {
                hsp = -2
                vsp = -3.2
                facing = -1
                INPUT_MOVE = -1
                audio_play_sound(sn_walljump, 0, false)
                can_dodge = 1
            }
            if place_meeting(x - 2, y, obj_wall)
            {
                hsp = 2
                vsp = -3.2
                facing = 1
                INPUT_MOVE = 1
                audio_play_sound(sn_walljump, 0, false)
                can_dodge = 1
            }
        }
        can_jump = 0
    }

    if(INPUT_GRAPPLE)
    {
        var inst = noone
        for(var i = 0; i < 64; i++)
        {
            var _i = instance_place(x + facing * (i * 8), y, obj_wall)
            if(_i)
            {
                inst = _i
                i = 64
                break
            }
        }
        if(inst)
        {
            state = "grapple"
            timer0 = 0
            gtx = (facing == 1) ? inst.bbox_left : inst.bbox_right
            gty = y
        }
    }

    if(!on_ground)
    {
        INPUT_DUCK = 0

        //cool backflip ledge save
        if(!place_meeting(x, y + 32, obj_wall)) && (!place_meeting(x - (sign(hsp) * 40), y - 8, obj_wall)) && (place_meeting(x - (sign(hsp) * 40), y + 8, obj_wall)) && (state == "normal") && (can_dodge) && (abs(x - target.x) < 80) && ((y - target.y) >= -8)
        {
            timer0 = 0;
            image_index = 0;
            state = "backflip_start";
        }
    }

    //randomly choose between moving and not moving toward the player
    if(chance <= 6) && (chance >= 1)
    {
        INPUT_MOVE = clamp(sign(target.x - x) + irandom_range(-1, 1), -1, 1)
    }

    // if(chance == 1) && (target.facing == -sign(facing)) && (state == "normal") && (can_dodge)
    // {
    //     timer0 = 0
    //     image_index = 0
    //     state = "backflip_start"
    // }

    // if(chance == 2) && (target.facing == -sign(facing)) && (state == "normal") && (can_dodge)
    // {
    //     flip_counter = 0
    //     timer0 = 0
    //     image_index = 0
    //     state = "backflip_x3"
    // }
}

//dinder into a backflip and then explode when player dies (lol, lmao)
if(instance_exists(obj_player_dead)) && (active)
{
    state = "dinder";
    active = 0;
    INPUT_MOVE = 0;
    image_index = 0;
    facing = sign(obj_player_dead.x - x);
}

image_xscale = sign(facing);
