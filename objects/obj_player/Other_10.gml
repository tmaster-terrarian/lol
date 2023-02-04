if(!place_meeting(x + sign(hsp), y - 4, oWall))
{
    for(var i = 0; i < 4; i++)
    {
        y -= 1;
        if(!place_meeting(x + sign(hsp), y, oWall))
        {
            x += sign(hsp);
            break;
        }
    }
}
for (var i = 0; i < 3; i++)
{
    if (abs(hsp) >= 1)
    {
        with(instance_create_depth((x + (4 * sign(facing))), random_range((bbox_bottom - 12), (bbox_bottom - 2)), (depth - 1), fx_dust))
        {
            sprite_index = spr_fx_dust2
            vz = 0
        }
        audio_play_sound(sn_player_land, 0, false)
    }
}
hsp = 0;
