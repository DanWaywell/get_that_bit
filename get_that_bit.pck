GDPC                �                                                                         X   res://.godot/exported/133200997/export-4290df4577efd4796dbdaf4e83ca6c2e-character.scn          �      ]���0�YMpah|���    P   res://.godot/exported/133200997/export-4d35b6806538f9d7f1eabac087f24885-door.scnp&      �      b�P�$���L    P   res://.godot/exported/133200997/export-c3dace8ad79a2d4daf94edd99cab8ebc-bit.scn  !      �      �#��{��>��	�S    X   res://.godot/exported/133200997/export-ccd0855d5f2f070ec090dc7de4648cb8-level_000.scn   �      B      ��j��K$�_SG����    P   res://.godot/exported/133200997/export-d68ddfd33cddc47712f5d1eef7ecdc36-game.scn�      n      ���Bw�O���X�s�`    ,   res://.godot/global_script_class_cache.cfg   ;      �       .�L܍��pC�W��    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex@+      �      �̛�*$q�*�́     H   res://.godot/imported/sprites.png-bb36f92a96c2b9ad48a8528dbf01963e.ctex         �       kj+��J�������d       res://.godot/uid_cache.bin  `?      �       �V�n�w�@#sb{�        res://assets/sprites.png.import �       �       s.��cjTWS��i�       res://autoload/game.gd  �      �      �d\o19@�̣���        res://autoload/game.tscn.remap  �8      a       �Q���r(mf�q�X3�p       res://character/character.gd             PUY�����8���
�    $   res://character/character.tscn.remapP9      f       �oxO��SQ�$��       res://icon.svg  �;      �      C��=U���^Qu��U3       res://icon.svg.import    8      �       XnKGxg+:'4�l�8        res://level/level_000.tscn.remap�9      f       2yFT�8f�k�C���       res://objects/bit.gd        �       �slW��:��/�V-p�<       res://objects/bit.tscn.remap0:      `       �j6�z�&*���_��       res://objects/door.gd   �%      �       ��$��0�.s= �Q�        res://objects/door.tscn.remap   �:      a       ꋿ2;}7��P1���       res://project.binary`@            F��sy��j�ö,���                GST2   @   @      ����               @ @        �   RIFF�   WEBPVP8L�   /?�7@�mS�i\�j۶a����W3Hڸ�}A�������H����� �p������=p_?�������6W���cg����s��`��i�-:+3�X��Zk��S�|^s�����  [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://b6tw7cndx85hk"
path="res://.godot/imported/sprites.png-bb36f92a96c2b9ad48a8528dbf01963e.ctex"
metadata={
"vram_texture": false
}
             extends Node


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(1280, 720))
			DisplayServer.window_set_position(Vector2i(320, 180))
     RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://autoload/game.gd ��������      local://PackedScene_6gny5          PackedScene          	         names "         Game    script    Node    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC  extends CharacterBody2D
class_name Character

const SPEED = 120.0
const DEFAULT_GRAVITY = 900.0
const JUMP_VELOCITY = -200.0
const COYOTE_TIME = 0.1
const JUMP_REDUCTION = 0.4
const GROUND_ACCEL = 0.6
const GROUND_DECEL = 0.5
const AIR_ACCEL = 0.4
const AIR_DECEL = 0.09

var gravity = DEFAULT_GRAVITY
var air_timer = 0.0
var input_direction = 0.0
var direction_facing = Vector2.RIGHT

var can_jump = true
var can_reduce_jump = true
var can_turn = true
var can_move = true

@onready var PrejumpTimer = $PrejumpTimer


func _physics_process(delta):	
	input_direction = Input.get_axis("left", "right")
	
	if not is_on_floor():
		air_timer += delta
		if velocity.y > 0:
			velocity.y += gravity * delta
		else:
			velocity.y += gravity *1.1 * delta
	else:
		air_timer = 0.0
	
	if can_jump:
		if Input.is_action_just_pressed("jump"):
			PrejumpTimer.start()
		if not PrejumpTimer.is_stopped() and air_timer < COYOTE_TIME:
			if Input.is_action_pressed("jump"):
				velocity.y = JUMP_VELOCITY
			else:
				velocity.y = JUMP_VELOCITY * JUMP_REDUCTION
			PrejumpTimer.stop()
	
	if can_reduce_jump:
		if velocity.y < 0 and Input.is_action_just_released("jump"):
			velocity.y *= JUMP_REDUCTION
	
	if can_turn:
		if input_direction > 0:
			direction_facing = Vector2.RIGHT
		elif input_direction < 0:
			direction_facing = Vector2.LEFT
	
	if can_move:
		if input_direction:
			if is_on_floor():
				velocity.x = lerp(velocity.x, input_direction * SPEED, GROUND_ACCEL)
			else:
				velocity.x = lerp(velocity.x, input_direction * SPEED, AIR_ACCEL)
		else:
			if is_on_floor():
				velocity.x = lerp(velocity.x, input_direction * SPEED, GROUND_DECEL)
			else:
				velocity.x = lerp(velocity.x, 0.0, AIR_DECEL)
	
		
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	get_tree().reload_current_scene()
         RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script    res://character/character.gd ��������
   Texture2D    res://assets/sprites.png �T���?      local://RectangleShape2D_cikdt �         local://PackedScene_etlne �         RectangleShape2D       
     �@  �@         PackedScene          	         names "      
   Character    z_index    collision_layer    script    CharacterBody2D    CollisionShape2D 	   position    shape 	   Sprite2D    texture    region_enabled    region_rect    VisibleOnScreenNotifier2D    PrejumpTimer    process_callback 
   wait_time 	   one_shot    Timer 0   _on_visible_on_screen_notifier_2d_screen_exited    screen_exited    	   variants    
                         
          ?                               A       A   A       )   �������?      node_count             nodes     9   ��������       ����                                        ����                                 ����   	      
                              ����                      ����            	                   conn_count             conns                                      node_paths              editable_instances              version             RSRC      RSRC                    PackedScene            ��������                                            )      resource_local_to_scene    resource_name    texture    margins    separation    texture_region_size    use_texture_padding    0:0/0 &   0:0/0/physics_layer_0/linear_velocity '   0:0/0/physics_layer_0/angular_velocity    0:0/0/script    1:0/0 &   1:0/0/physics_layer_0/linear_velocity '   1:0/0/physics_layer_0/angular_velocity    1:0/0/script    2:0/0 &   2:0/0/physics_layer_0/linear_velocity '   2:0/0/physics_layer_0/angular_velocity    2:0/0/script    3:0/0 &   3:0/0/physics_layer_0/linear_velocity '   3:0/0/physics_layer_0/angular_velocity    3:0/0/script    0:1/0 &   0:1/0/physics_layer_0/linear_velocity '   0:1/0/physics_layer_0/angular_velocity '   0:1/0/physics_layer_0/polygon_0/points    0:1/0/script    script    tile_shape    tile_layout    tile_offset_axis 
   tile_size    uv_clipping     physics_layer_0/collision_layer    physics_layer_0/collision_mask 
   sources/1    tile_proxies/source_level    tile_proxies/coords_level    tile_proxies/alternative_level 	   _bundled    
   Texture2D    res://assets/sprites.png �T���?   PackedScene    res://character/character.tscn ��C�E��   PackedScene    res://objects/bit.tscn ���/u"�?   PackedScene    res://objects/door.tscn j�G:�Y�0   !   local://TileSetAtlasSource_1uhlf �         local://TileSet_h5y74          local://PackedScene_8fheg k         TileSetAtlasSource                    -                      
           	          
                   
                                        
                                        
                                        
                        %        ��  ��  �@  ��  �@  �@  ��  �@               TileSet        -         "         #          $                      PackedScene    (      	         names "         Leve000    Node2D    TileMap 	   tile_set    format    layer_0/tile_data 
   Character 	   position    Bit    Bit2    Bit3    Bit4    Door    	   variants                          �                                                                                                                   	        
                                                                                                                	        	        
                                         
        
        
        
        
        
        
                                                                                                
     �A  �B         
     (C  �B
     C  �B
     �B  �B
     �B  �B         
     dC  �B      node_count             nodes     J   ��������       ����                      ����                                  ���                           ���                           ���	                           ���
                           ���            	               ���   
                      conn_count              conns               node_paths              editable_instances              version             RSRC              extends Area2D

var picked_up = false

@onready var collision = $CollisionShape2D

func _bit_picked_up():
	picked_up = true
	collision.set_deferred("disabled", true)
	queue_free()

func _on_body_entered(body):
	if body is Character:
		_bit_picked_up()
    RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script    res://objects/bit.gd ��������
   Texture2D    res://assets/sprites.png �T���?      local://RectangleShape2D_6pwx8 �         local://PackedScene_2y552 �         RectangleShape2D       
     �@  �@         PackedScene          	         names "         Bit    collision_layer    collision_mask    monitorable    script    Area2D    CollisionShape2D    shape 	   Sprite2D    texture    region_enabled    region_rect    _on_body_entered    body_entered    	   variants                                                                            A   A      node_count             nodes     %   ��������       ����                                              ����                           ����   	      
                      conn_count             conns                                       node_paths              editable_instances              version             RSRC    extends Area2D


func _finish_level():
	get_tree().reload_current_scene()


func _on_body_entered(body):
	if body is Character:
		_finish_level()
              RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script    res://objects/door.gd ��������
   Texture2D    res://assets/sprites.png �T���?      local://RectangleShape2D_efe13 �         local://PackedScene_3afpy �         RectangleShape2D       
     �@  �@         PackedScene          	         names "         Door    collision_layer    collision_mask    monitorable    script    Area2D    CollisionShape2D 	   position    shape 	   Sprite2D    texture    region_enabled    region_rect    _on_body_entered    body_entered    	   variants    	                                 
          ?                              �A       A   A      node_count             nodes     '   ��������       ����                                              ����                           	   	   ����   
                            conn_count             conns                                       node_paths              editable_instances              version             RSRC GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://sa8rirdtdu0m"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 [remap]

path="res://.godot/exported/133200997/export-d68ddfd33cddc47712f5d1eef7ecdc36-game.scn"
               [remap]

path="res://.godot/exported/133200997/export-4290df4577efd4796dbdaf4e83ca6c2e-character.scn"
          [remap]

path="res://.godot/exported/133200997/export-ccd0855d5f2f070ec090dc7de4648cb8-level_000.scn"
          [remap]

path="res://.godot/exported/133200997/export-c3dace8ad79a2d4daf94edd99cab8ebc-bit.scn"
[remap]

path="res://.godot/exported/133200997/export-4d35b6806538f9d7f1eabac087f24885-door.scn"
               list=Array[Dictionary]([{
"base": &"CharacterBody2D",
"class": &"Character",
"icon": "",
"language": &"GDScript",
"path": "res://character/character.gd"
}])
   <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             �T���?   res://assets/sprites.png
FZu   res://autoload/game.tscn��C�E��   res://character/character.tscn4��|�   res://level/level_000.tscn���/u"�?   res://objects/bit.tscnj�G:�Y�0   res://objects/door.tscn��3��   res://icon.svg     ECFG      application/config/name         Get That Bit   application/run/main_scene$         res://level/level_000.tscn     application/config/features   "         4.1    Mobile     application/config/icon         res://icon.svg     autoload/Game$         *res://autoload/game.tscn   "   display/window/size/viewport_width         #   display/window/size/viewport_height      �      display/window/size/mode            display/window/stretch/mode         viewport
   input/left,              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis       
   axis_value       ��   script         input/right,              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis       
   axis_value       �?   script         input/up,              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       ��   script      
   input/down,              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index         pressure          pressed          script            InputEventJoypadMotion        resource_local_to_scene           resource_name             device     ����   axis      
   axis_value       �?   script      
   input/jump|              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode       	   key_label             unicode           echo          script            InputEventJoypadButton        resource_local_to_scene           resource_name             device     ����   button_index          pressure          pressed          script         input/fullscreen�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   & @ 	   key_label             unicode           echo          script      9   rendering/textures/canvas_textures/default_texture_filter          #   rendering/renderer/rendering_method         mobile  2   rendering/environment/defaults/default_clear_color                    �?             