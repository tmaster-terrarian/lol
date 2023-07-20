if(draw_ui)
{
    var drawbuffs = 0

    if(instance_exists(obj_player) || instance_exists(obj_player_dead))
    {
        draw_sprite(spr_hpbar2_back, 0, 0, 0)

        var p = obj_player
        var dtxt = ""
        if(instance_exists(p))
        {
            draw_sprite_ext(spr_hpbar2_fill2, 0, 19, 4, ceil((hp_change / p.hp_max) * (74 * p.stats.curse)), 1, 0, c_white, 1)
            draw_sprite_ext(spr_hpbar2_fill, 0, 19, 4, ceil((p.hp / p.hp_max) * (74 * p.stats.curse)), 1, 0, c_white, 1)
            if(ceil(hp_change) < ceil(p.hp))
            {
                draw_sprite_ext(spr_hpbar2_fill3, 0, 19 + ceil((p.hp / p.hp_max) * (74 * p.stats.curse)), 4, ceil(-(p.hp - hp_change)), 1, 0, c_white, 1)
            }

            playerlasthpmax = ceil(p.hp_max)
            playerlasthp = ceil(p.hp)
            playercurse = p.stats.curse
            dtxt = string(ceil(p.hp)) + "/" + string(ceil(p.hp_max))
        }
        else
        {
            draw_sprite_ext(spr_hpbar2_fill2, 0, 19, 4, ceil((hp_change / playerlasthpmax) * (74 * p.stats.curse)), 1, 0, c_white, 1)

            dtxt = string(playerlasthp) + "/" + string(playerlasthpmax)
        }
        drawbuffs = 1

        if(playercurse < 1)
            draw_sprite_ext(spr_curseoverlay, 0, 94, 3, ceil(playercurse * 76)/76, 1, 0, c_white, 1)

        draw_sprite(spr_hpbar2_front, 0, 0, 0)

        draw_set_font(hudfont)
        draw_set_halign(fa_center)
        draw_set_valign(fa_top)

        var c = c_black
        draw_text_color(19 + ceil(37 * playercurse), 5, dtxt, c,c,c,c,1)
        var c = c_white
        draw_text_color(19 + ceil(37 * playercurse), 4, dtxt, c,c,c,c,1)
    }

    if(instance_exists(oGun))
    {
        var bomb_timer_max = oGun.bomb_timer_max;
        var bomb_timer = -oGun.firingdelaybomb + bomb_timer_max;
        if(bomb_timer > bomb_timer_max) bomb_timer = bomb_timer_max;

        draw_sprite(spr_hud_bombtimer, (bomb_timer * (1/bomb_timer_max)) * 10, 12, 10);
    }
    else if(instance_exists(obj_player_dead))
    {
        draw_sprite(spr_hud_bombtimer, 0, 13, 10);
    }

    if(drawbuffs)
    {
        with(obj_player)
        {
            buffoffsi = 0
            foreach(buffs as (buff, name, i)
            {
                var buffsx = 24
                var buffsy = 18
                if(instance_exists(oGun))
                {
                    buffsx = 29
                    buffsy = 26
                }
                if(buff.stacks > 0)
                {
                    var spr = asset_get_index("spr_" + buff.name)
                    draw_sprite((spr != -1) ? spr : spr_buff_missing, 0, buffsx + (10 * (i + buffoffsi)), buffsy)
                }
                else buffoffsi--
            })
        }
    }

    with(obj_player)
    {
        for(var i = 0; i < array_length(items); i++)
        {
            var _spr = asset_get_index("spr_item_" + items[i].item_id)
            draw_sprite_outlined_ext((_spr != -1) ? _spr : spr_buff_missing, 0, 10 + 16 * i, 144 - 10, 1, 1, 0, c_white, itemdata.rarity_colors[global.itemdefs[$ items[i].item_id].rarity], 1, 1, 0)
        }
        for(var i = 0; i < array_length(items); i++)
        {
            if(items[i].stacks > 1)
            {
                draw_set_halign(fa_right); draw_set_valign(fa_bottom); draw_set_font(other.hudfontstacks)
                draw_text(18 + 16 * i, 144 - 2, string(items[i].stacks))
            }
        }
    }

    if(gm.drawbossbar)
    {
        var c = c_black
        draw_rectangle_color(34, 131, 249, 138, c, c, c, c, false)

        var b = gm.currentboss
        if(instance_exists(b) && b.hp)
        {
            draw_sprite_ext(spr_bossbar_fill, 0, 34, 131, (b.hp / b.hpmax) * 216, 1, 0, c_white, 1)
        }

        draw_sprite(spr_bossbar_frame, 0, 0, 131)
    }
}
