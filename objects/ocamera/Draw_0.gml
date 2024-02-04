if(_zoom != zoom)
{
	surface_resize(application_surface, 256 / zoom, 144 / zoom);
	display_set_gui_size(256 / zoom, 144 / zoom)
	_zoom = zoom
}

if(draw_ui)
{
    var offsetx = 4;
    var offsety = 4;
    var xpos = camera_get_view_x(cam);
    var ypos = camera_get_view_y(cam);

    if(instance_exists(obj_player))
    {
        var player_health = obj_player.hp;

        draw_sprite(spr_hp_icon, 0, xpos + offsetx, ypos + offsety);
        draw_sprite(spr_hp_bar_start, 0, xpos + offsetx + 16, ypos + offsety);

        for(var i = 0; i < global.playermaxhealth; i++)
        {
            if(i > player_health - 1) draw_sprite(spr_hp_bar, 1, xpos + offsetx + (i * 12) + 16, ypos + offsety);
            else draw_sprite(spr_hp_bar, 0, xpos + offsetx + (i * 12) + 16, ypos + offsety);
        }
        draw_sprite(spr_hp_bar_end, 0, xpos + offsetx + (global.playermaxhealth * 12) + 16, ypos + offsety);
    }
    else if(instance_exists(obj_player_dead))
    {
        draw_sprite(spr_hp_icon, 0, xpos + offsetx, ypos + offsety);
        draw_sprite(spr_hp_bar_start, 0, xpos + offsetx + 16, ypos + offsety);

        for(var i = 0; i < global.playermaxhealth; i++)
        {
            draw_sprite(spr_hp_bar, 1, xpos + offsetx + (i * 12) + 16, ypos + offsety);
        }
        draw_sprite(spr_hp_bar_end, 0, xpos + offsetx + (global.playermaxhealth * 12) + 16, ypos + offsety);
    }

    if(instance_exists(oGun))
    {

        var bomb_timer_max = oGun.bomb_timer_max;
        var bomb_timer = -oGun.firingdelaybomb + bomb_timer_max;
        if(bomb_timer > bomb_timer_max) bomb_timer = bomb_timer_max;

        draw_sprite(spr_hud_bombtimer, (bomb_timer * (1/bomb_timer_max)) * 10, xpos + offsetx + 13, ypos + offsety + 9);
    }
    else if(instance_exists(obj_player_dead))
    {
        draw_sprite(spr_hud_bombtimer, 0, xpos + offsetx + 13, ypos + offsety + 9);
    }

    if(oGameManager.drawbossbar)
    {
        var c = c_black
        draw_rectangle_color(xpos + 34, ypos + 131, xpos + 249, ypos + 138, c, c, c, c, false)

        var b = oGameManager.currentboss
        if(instance_exists(b) && b.hp)
        {
            draw_sprite_ext(spr_bossbar_fill, 0, xpos + 34, ypos + 131, (b.hp / b.hpmax) * 216, 1, 0, c_white, 1)
        }

        draw_sprite(spr_bossbar_frame, 0, xpos, ypos + 131)
    }
}
