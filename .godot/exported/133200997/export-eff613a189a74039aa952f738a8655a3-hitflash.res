RSRC                    VisualShader            ��������                                            0      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    parameter_name 
   qualifier    default_value_enabled    default_value    script    input_name    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        -   local://VisualShaderNodeColorParameter_4swbe S      /   local://VisualShaderNodeBooleanParameter_wtb37 �      !   local://VisualShaderNodeIf_ablni �      $   local://VisualShaderNodeInput_syu4t �      8   res://Game Folder/game_components/shaders/hitflash.tres �         VisualShaderNodeColorParameter             Tint          
      !   VisualShaderNodeBooleanParameter             enabled          
         VisualShaderNodeIf                                      �?      )   �h㈵��>                                                               
         VisualShaderNodeInput             color 
         VisualShader          �  shader_type canvas_item;
render_mode blend_mix;

uniform bool enabled = false;
uniform vec4 Tint : source_color = vec4(1.000000, 1.000000, 1.000000, 1.000000);



void fragment() {
// BooleanParameter:3
	bool n_out3p0 = enabled;


// ColorParameter:2
	vec4 n_out2p0 = Tint;


// Input:5
	vec4 n_out5p0 = COLOR;


	vec3 n_out4p0;
// If:4
	float n_in4p1 = 1.00000;
	float n_in4p2 = 0.00001;
	if(abs((n_out3p0 ? 1.0 : 0.0) - n_in4p1) < n_in4p2)
	{
		n_out4p0 = vec3(n_out2p0.xyz);
	}
	else if((n_out3p0 ? 1.0 : 0.0) < n_in4p1)
	{
		n_out4p0 = vec3(n_out5p0.xyz);
	}
	else
	{
		n_out4p0 = vec3(n_out5p0.xyz);
	}


// Output:0
	COLOR.rgb = n_out4p0;


}
                       
     �C   C                
     �B  �B               
     �B  ��               
     �C  ��               
     �B  �C                                                                              
      RSRC