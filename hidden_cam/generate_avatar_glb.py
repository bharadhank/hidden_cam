import struct
import json
import math
import os

def create_cube_mesh(cx, cy, cz, sx, sy, sz):
    """Generate vertices, normals, and indices for a box."""
    hx, hy, hz = sx / 2.0, sy / 2.0, sz / 2.0
    # 6 faces * 4 vertices = 24 vertices
    raw_faces = [
        # Front (+Z)
        ([(-hx, -hy,  hz), ( hx, -hy,  hz), ( hx,  hy,  hz), (-hx,  hy,  hz)], ( 0,  0,  1)),
        # Back (-Z)
        ([( hx, -hy, -hz), (-hx, -hy, -hz), (-hx,  hy, -hz), ( hx,  hy, -hz)], ( 0,  0, -1)),
        # Top (+Y)
        ([(-hx,  hy,  hz), ( hx,  hy,  hz), ( hx,  hy, -hz), (-hx,  hy, -hz)], ( 0,  1,  0)),
        # Bottom (-Y)
        ([(-hx, -hy, -hz), ( hx, -hy, -hz), ( hx, -hy,  hz), (-hx, -hy,  hz)], ( 0, -1,  0)),
        # Right (+X)
        ([( hx, -hy,  hz), ( hx, -hy, -hz), ( hx,  hy, -hz), ( hx,  hy,  hz)], ( 1,  0,  0)),
        # Left (-X)
        ([(-hx, -hy, -hz), (-hx, -hy,  hz), (-hx,  hy,  hz), (-hx,  hy, -hz)], (-1,  0,  0)),
    ]
    
    verts = []
    norms = []
    indices = []
    
    for corners, normal in raw_faces:
        base_idx = len(verts)
        for x, y, z in corners:
            verts.append((cx + x, cy + y, cz + z))
            norms.append(normal)
        indices.extend([base_idx, base_idx + 1, base_idx + 2, base_idx, base_idx + 2, base_idx + 3])
        
    return verts, norms, indices

def create_cylinder_mesh(cx, cy, cz, r_top, r_bot, height, segments=12):
    """Generate stylized cylinder/tapered limb."""
    verts = []
    norms = []
    indices = []
    hy = height / 2.0
    
    for i in range(segments):
        theta = 2.0 * math.pi * i / segments
        cos_t, sin_t = math.cos(theta), math.sin(theta)
        
        # Bottom vertex
        verts.append((cx + r_bot * cos_t, cy - hy, cz + r_bot * sin_t))
        norms.append((cos_t, 0.0, sin_t))
        # Top vertex
        verts.append((cx + r_top * cos_t, cy + hy, cz + r_top * sin_t))
        norms.append((cos_t, 0.0, sin_t))
        
    for i in range(segments):
        b0 = 2 * i
        t0 = 2 * i + 1
        b1 = 2 * ((i + 1) % segments)
        t1 = 2 * ((i + 1) % segments) + 1
        indices.extend([b0, b1, t0, t0, b1, t1])
        
    return verts, norms, indices

def create_shield_mesh(cx, cy, cz, scale=0.3):
    """Generate a cute 3D shield emblem mesh."""
    # Front and back shield contour
    pts_2d = [
        (0.0,  0.5),   # Top center peak
        (0.4,  0.4),   # Top right corner
        (0.4,  0.0),   # Mid right
        (0.0, -0.5),   # Bottom sharp point
        (-0.4, 0.0),   # Mid left
        (-0.4, 0.4),   # Top left corner
    ]
    thickness = 0.08 * scale
    verts = []
    norms = []
    indices = []
    
    # Front vertices (z = +thickness/2)
    center_f = len(verts)
    verts.append((cx, cy, cz + thickness / 2))
    norms.append((0, 0, 1))
    
    for x, y in pts_2d:
        verts.append((cx + x * scale, cy + y * scale, cz + thickness / 2))
        norms.append((0, 0, 1))
        
    # Front fan
    for i in range(len(pts_2d)):
        nxt = (i + 1) % len(pts_2d)
        indices.extend([center_f, center_f + 1 + i, center_f + 1 + nxt])
        
    # Back vertices (z = -thickness/2)
    center_b = len(verts)
    verts.append((cx, cy, cz - thickness / 2))
    norms.append((0, 0, -1))
    
    for x, y in pts_2d:
        verts.append((cx + x * scale, cy + y * scale, cz - thickness / 2))
        norms.append((0, 0, -1))
        
    # Back fan (reversed winding)
    for i in range(len(pts_2d)):
        nxt = (i + 1) % len(pts_2d)
        indices.extend([center_b, center_b + 1 + nxt, center_b + 1 + i])
        
    return verts, norms, indices

def euler_to_quat(pitch, yaw, roll):
    """Convert Euler angles (in radians: X, Y, Z) to quaternion (x, y, z, w)."""
    cy = math.cos(yaw * 0.5)
    sy = math.sin(yaw * 0.5)
    cp = math.cos(pitch * 0.5)
    sp = math.sin(pitch * 0.5)
    cr = math.cos(roll * 0.5)
    sr = math.sin(roll * 0.5)

    w = cr * cp * cy + sr * sp * sy
    x = sr * cp * cy - cr * sp * sy
    y = cr * sp * cy + sr * cp * sy
    z = cr * cp * sy - sr * sp * cy
    return (x, y, z, w)

def build_gltf_model():
    # Model parts with respective materials
    # Materials:
    # 0: Skin (Warm tone)
    # 1: Hair (Warm chestnut brown bob)
    # 2: Cream Uniform (#F7F3E8)
    # 3: Sage Green (#A8C3A0)
    # 4: Natural Teal (#4F8F89)
    # 5: Shield Hologram (Glowing teal emissive)
    # 6: Eye dark / hazel
    
    materials = [
        # 0: Skin
        {
            "name": "AriaSkin",
            "pbrMetallicRoughness": {
                "baseColorFactor": [0.96, 0.82, 0.73, 1.0],
                "metallicFactor": 0.05,
                "roughnessFactor": 0.65
            }
        },
        # 1: Hair
        {
            "name": "AriaHair",
            "pbrMetallicRoughness": {
                "baseColorFactor": [0.38, 0.22, 0.15, 1.0],
                "metallicFactor": 0.1,
                "roughnessFactor": 0.5
            }
        },
        # 2: Cream Uniform Jacket
        {
            "name": "SafeLensCreamUniform",
            "pbrMetallicRoughness": {
                "baseColorFactor": [0.97, 0.95, 0.91, 1.0],
                "metallicFactor": 0.05,
                "roughnessFactor": 0.75
            }
        },
        # 3: Sage Green Collar & Trim
        {
            "name": "SafeLensSageTrim",
            "pbrMetallicRoughness": {
                "baseColorFactor": [0.66, 0.76, 0.63, 1.0],
                "metallicFactor": 0.05,
                "roughnessFactor": 0.75
            }
        },
        # 4: Teal Belt & Accents
        {
            "name": "SafeLensTealAccent",
            "pbrMetallicRoughness": {
                "baseColorFactor": [0.31, 0.56, 0.54, 1.0],
                "metallicFactor": 0.1,
                "roughnessFactor": 0.4
            }
        },
        # 5: Glowing Shield Hologram
        {
            "name": "SafeLensShieldHolo",
            "pbrMetallicRoughness": {
                "baseColorFactor": [0.25, 0.9, 0.85, 0.9],
                "metallicFactor": 0.2,
                "roughnessFactor": 0.2
            },
            "emissiveFactor": [0.2, 0.7, 0.65],
            "alphaMode": "BLEND"
        },
        # 6: Eyes
        {
            "name": "AriaEyes",
            "pbrMetallicRoughness": {
                "baseColorFactor": [0.22, 0.14, 0.10, 1.0],
                "metallicFactor": 0.0,
                "roughnessFactor": 0.2
            }
        }
    ]
    
    # We will build distinct meshes for modular nodes:
    # Nodes:
    # 0: Root (Character root pivot)
    # 1: Torso (Cream jacket + teal belt + sage collar)
    # 2: Head (Head mesh + Hair bob + Eyes)
    # 3: LeftArm
    # 4: LeftForearm & Hand
    # 5: RightArm
    # 6: RightForearm & Hand
    # 7: ShieldBadge
    # 8: LowerBody (Skirt/legs in sage)

    # Geometry per node
    # Node 1: Torso
    torso_verts, torso_norms, torso_idx = create_cube_mesh(0, 0.95, 0, 0.42, 0.45, 0.28)
    collar_verts, collar_norms, collar_idx = create_cube_mesh(0, 1.18, 0.02, 0.32, 0.08, 0.24)
    belt_verts, belt_norms, belt_idx = create_cube_mesh(0, 0.78, 0, 0.43, 0.07, 0.29)
    
    # Node 2: Head (center around 1.38, relative to neck at y=1.22)
    # Head relative to head node (0, 0, 0)
    head_verts, head_norms, head_idx = create_cube_mesh(0, 0.14, 0, 0.34, 0.36, 0.32)
    # Hair bob top & sides
    hair_top_v, hair_top_n, hair_top_i = create_cube_mesh(0, 0.24, -0.02, 0.38, 0.22, 0.38)
    hair_side_l_v, hair_side_l_n, hair_side_l_i = create_cube_mesh(-0.18, 0.10, -0.02, 0.09, 0.32, 0.36)
    hair_side_r_v, hair_side_r_n, hair_side_r_i = create_cube_mesh(0.18, 0.10, -0.02, 0.09, 0.32, 0.36)
    hair_back_v, hair_back_n, hair_back_i = create_cube_mesh(0, 0.10, -0.16, 0.38, 0.32, 0.10)
    # Eyes
    eye_l_v, eye_l_n, eye_l_i = create_cube_mesh(-0.08, 0.14, 0.165, 0.07, 0.06, 0.02)
    eye_r_v, eye_r_n, eye_r_i = create_cube_mesh(0.08, 0.14, 0.165, 0.07, 0.06, 0.02)
    
    # Node 3: Left Arm (Upper) - relative to shoulder (-0.26, 1.12, 0)
    l_arm_v, l_arm_n, l_arm_i = create_cylinder_mesh(0, -0.12, 0, 0.07, 0.065, 0.24)
    # Node 4: Left Forearm & Hand - relative to elbow (0, -0.24, 0)
    l_forearm_v, l_forearm_n, l_forearm_i = create_cylinder_mesh(0, -0.10, 0, 0.06, 0.055, 0.20)
    l_hand_v, l_hand_n, l_hand_i = create_cube_mesh(0, -0.24, 0.02, 0.07, 0.09, 0.06)

    # Node 5: Right Arm (Upper) - relative to shoulder (0.26, 1.12, 0)
    r_arm_v, r_arm_n, r_arm_i = create_cylinder_mesh(0, -0.12, 0, 0.07, 0.065, 0.24)
    # Node 6: Right Forearm & Hand - relative to elbow (0, -0.24, 0)
    r_forearm_v, r_forearm_n, r_forearm_i = create_cylinder_mesh(0, -0.10, 0, 0.06, 0.055, 0.20)
    r_hand_v, r_hand_n, r_hand_i = create_cube_mesh(0, -0.24, 0.02, 0.07, 0.09, 0.06)

    # Node 7: Shield Badge (floating / attached near chest/right hand)
    shield_v, shield_n, shield_i = create_shield_mesh(0, 0, 0, scale=0.35)

    # Node 8: Lower Body (skirt + legs)
    skirt_v, skirt_n, skirt_i = create_cylinder_mesh(0, 0.62, 0, 0.22, 0.26, 0.26)
    legs_l_v, legs_l_n, legs_l_i = create_cylinder_mesh(-0.10, 0.30, 0, 0.065, 0.06, 0.40)
    legs_r_v, legs_r_n, legs_r_i = create_cylinder_mesh(0.10, 0.30, 0, 0.065, 0.06, 0.40)
    shoes_l_v, shoes_l_n, shoes_l_i = create_cube_mesh(-0.10, 0.06, 0.04, 0.10, 0.08, 0.16)
    shoes_r_v, shoes_r_n, shoes_r_i = create_cube_mesh(0.10, 0.06, 0.04, 0.10, 0.08, 0.16)

    # Binary packaging
    bin_data = bytearray()
    buffer_views = []
    accessors = []
    meshes = []
    
    def add_buffer_data(data, target=None):
        nonlocal bin_data
        # 4-byte align
        while len(bin_data) % 4 != 0:
            bin_data.append(0)
        offset = len(bin_data)
        bin_data.extend(data)
        bv_idx = len(buffer_views)
        bv_dict = {
            "buffer": 0,
            "byteOffset": offset,
            "byteLength": len(data)
        }
        if target:
            bv_dict["target"] = target
        buffer_views.append(bv_dict)
        return bv_idx

    def add_mesh_primitive(verts, norms, indices, mat_idx):
        # Pack indices (uint16)
        idx_bytes = struct.pack(f'<{len(indices)}H', *indices)
        idx_bv = add_buffer_data(idx_bytes, target=34963)
        idx_acc = len(accessors)
        accessors.append({
            "bufferView": idx_bv,
            "byteOffset": 0,
            "componentType": 5123, # UNSIGNED_SHORT
            "count": len(indices),
            "type": "SCALAR",
            "min": [min(indices)],
            "max": [max(indices)]
        })

        # Pack positions (vec3 float32)
        pos_floats = [coord for pt in verts for coord in pt]
        pos_bytes = struct.pack(f'<{len(pos_floats)}f', *pos_floats)
        pos_bv = add_buffer_data(pos_bytes, target=34962)
        pos_acc = len(accessors)
        min_x = min(pt[0] for pt in verts)
        max_x = max(pt[0] for pt in verts)
        min_y = min(pt[1] for pt in verts)
        max_y = max(pt[1] for pt in verts)
        min_z = min(pt[2] for pt in verts)
        max_z = max(pt[2] for pt in verts)
        accessors.append({
            "bufferView": pos_bv,
            "byteOffset": 0,
            "componentType": 5126, # FLOAT
            "count": len(verts),
            "type": "VEC3",
            "min": [min_x, min_y, min_z],
            "max": [max_x, max_y, max_z]
        })

        # Pack normals (vec3 float32)
        norm_floats = [coord for n in norms for coord in n]
        norm_bytes = struct.pack(f'<{len(norm_floats)}f', *norm_floats)
        norm_bv = add_buffer_data(norm_bytes, target=34962)
        norm_acc = len(accessors)
        accessors.append({
            "bufferView": norm_bv,
            "byteOffset": 0,
            "componentType": 5126,
            "count": len(norms),
            "type": "VEC3"
        })

        return {
            "attributes": {
                "POSITION": pos_acc,
                "NORMAL": norm_acc
            },
            "indices": idx_acc,
            "material": mat_idx
        }

    # Mesh 0: Torso (Primitives: jacket, collar, belt)
    prim_torso = add_mesh_primitive(torso_verts, torso_norms, torso_idx, mat_idx=2) # Cream
    prim_collar = add_mesh_primitive(collar_verts, collar_norms, collar_idx, mat_idx=3) # Sage
    prim_belt = add_mesh_primitive(belt_verts, belt_norms, belt_idx, mat_idx=4) # Teal
    mesh_torso_idx = len(meshes)
    meshes.append({"name": "TorsoMesh", "primitives": [prim_torso, prim_collar, prim_belt]})

    # Mesh 1: Head (Head skin, Hair bob, Eyes)
    prim_head = add_mesh_primitive(head_verts, head_norms, head_idx, mat_idx=0) # Skin
    # Combine hair parts
    hair_all_v = hair_top_v + hair_side_l_v + hair_side_r_v + hair_back_v
    hair_all_n = hair_top_n + hair_side_l_n + hair_side_r_n + hair_back_n
    hair_all_i = []
    cur_v_off = 0
    for v_chunk, i_chunk in [(hair_top_v, hair_top_i), (hair_side_l_v, hair_side_l_i), (hair_side_r_v, hair_side_r_i), (hair_back_v, hair_back_i)]:
        hair_all_i.extend([idx + cur_v_off for idx in i_chunk])
        cur_v_off += len(v_chunk)
    prim_hair = add_mesh_primitive(hair_all_v, hair_all_n, hair_all_i, mat_idx=1) # Hair
    prim_eyes = add_mesh_primitive(eye_l_v + eye_r_v, eye_l_n + eye_r_n, eye_l_i + [i + len(eye_l_v) for i in eye_r_i], mat_idx=6) # Eyes
    mesh_head_idx = len(meshes)
    meshes.append({"name": "HeadMesh", "primitives": [prim_head, prim_hair, prim_eyes]})

    # Mesh 2: Left Upper Arm
    prim_l_arm = add_mesh_primitive(l_arm_v, l_arm_n, l_arm_i, mat_idx=2) # Cream
    mesh_l_arm_idx = len(meshes)
    meshes.append({"name": "LeftArmMesh", "primitives": [prim_l_arm]})

    # Mesh 3: Left Forearm & Hand
    prim_l_fa = add_mesh_primitive(l_forearm_v, l_forearm_n, l_forearm_i, mat_idx=3) # Sage cuff
    prim_l_hand = add_mesh_primitive(l_hand_v, l_hand_n, l_hand_i, mat_idx=0) # Skin
    mesh_l_fa_idx = len(meshes)
    meshes.append({"name": "LeftForearmMesh", "primitives": [prim_l_fa, prim_l_hand]})

    # Mesh 4: Right Upper Arm
    prim_r_arm = add_mesh_primitive(r_arm_v, r_arm_n, r_arm_i, mat_idx=2) # Cream
    mesh_r_arm_idx = len(meshes)
    meshes.append({"name": "RightArmMesh", "primitives": [prim_r_arm]})

    # Mesh 5: Right Forearm & Hand
    prim_r_fa = add_mesh_primitive(r_forearm_v, r_forearm_n, r_forearm_i, mat_idx=3) # Sage cuff
    prim_r_hand = add_mesh_primitive(r_hand_v, r_hand_n, r_hand_i, mat_idx=0) # Skin
    mesh_r_fa_idx = len(meshes)
    meshes.append({"name": "RightForearmMesh", "primitives": [prim_r_fa, prim_r_hand]})

    # Mesh 6: Shield Badge
    prim_shield = add_mesh_primitive(shield_v, shield_n, shield_i, mat_idx=5) # Glowing hologram
    mesh_shield_idx = len(meshes)
    meshes.append({"name": "ShieldMesh", "primitives": [prim_shield]})

    # Mesh 7: Lower Body
    prim_skirt = add_mesh_primitive(skirt_v, skirt_n, skirt_i, mat_idx=3) # Sage
    legs_v = legs_l_v + legs_r_v
    legs_n = legs_l_n + legs_r_n
    legs_i = legs_l_i + [i + len(legs_l_v) for i in legs_r_i]
    prim_legs = add_mesh_primitive(legs_v, legs_n, legs_i, mat_idx=0) # Skin
    shoes_v = shoes_l_v + shoes_r_v
    shoes_n = shoes_l_n + shoes_r_n
    shoes_i = shoes_l_i + [i + len(shoes_l_v) for i in shoes_r_i]
    prim_shoes = add_mesh_primitive(shoes_v, shoes_n, shoes_i, mat_idx=4) # Teal shoes
    mesh_lower_idx = len(meshes)
    meshes.append({"name": "LowerBodyMesh", "primitives": [prim_skirt, prim_legs, prim_shoes]})

    # Define Node hierarchy
    # 0: AriaRoot
    # 1: TorsoNode (Mesh 0)
    # 2: HeadNode (Mesh 1)
    # 3: LeftShoulderNode (Mesh 2)
    # 4: LeftElbowNode (Mesh 3)
    # 5: RightShoulderNode (Mesh 4)
    # 6: RightElbowNode (Mesh 5)
    # 7: ShieldBadgeNode (Mesh 6)
    # 8: LowerBodyNode (Mesh 7)

    nodes = [
        # 0: AriaRoot
        {
            "name": "AriaRoot",
            "children": [1, 8],
            "translation": [0, 0, 0]
        },
        # 1: TorsoNode
        {
            "name": "Torso",
            "mesh": mesh_torso_idx,
            "children": [2, 3, 5, 7],
            "translation": [0, 0, 0]
        },
        # 2: HeadNode
        {
            "name": "Head",
            "mesh": mesh_head_idx,
            "translation": [0, 1.24, 0]
        },
        # 3: LeftShoulderNode
        {
            "name": "LeftShoulder",
            "mesh": mesh_l_arm_idx,
            "children": [4],
            "translation": [-0.25, 1.12, 0]
        },
        # 4: LeftElbowNode
        {
            "name": "LeftElbow",
            "mesh": mesh_l_fa_idx,
            "translation": [0, -0.24, 0]
        },
        # 5: RightShoulderNode
        {
            "name": "RightShoulder",
            "mesh": mesh_r_arm_idx,
            "children": [6],
            "translation": [0.25, 1.12, 0]
        },
        # 6: RightElbowNode
        {
            "name": "RightElbow",
            "mesh": mesh_r_fa_idx,
            "translation": [0, -0.24, 0]
        },
        # 7: ShieldBadgeNode
        {
            "name": "ShieldBadge",
            "mesh": mesh_shield_idx,
            "translation": [0.0, 0.98, 0.18]
        },
        # 8: LowerBodyNode
        {
            "name": "LowerBody",
            "mesh": mesh_lower_idx,
            "translation": [0, 0, 0]
        }
    ]

    # ANIMATIONS PIPELINE
    # Named animations requested:
    # 1. idle: subtle breathing, gentle movement
    # 2. greeting: friendly smile, hand wave
    # 3. explaining: gentle hand gestures, attentive expression
    # 4. scanning: attentive pose, small scanning gesture, shield forward
    # 5. pointing: gentle pointing gesture
    # 6. processing: calm idle pose
    # 7. reassuring: gentle nod, calm expression
    # 8. paused: neutral pose, stop unnecessary motion
    
    animations = []
    
    def create_animation(anim_name, duration_sec, node_tracks):
        """
        node_tracks: dict {
            node_idx: {
                'rotation': [(time, (qx, qy, qz, qw)), ...],
                'translation': [(time, (tx, ty, tz)), ...]
            }
        }
        """
        channels = []
        samplers = []
        
        for node_idx, track_types in node_tracks.items():
            for prop_name, keyframes in track_types.items():
                times = [kf[0] for kf in keyframes]
                vals = [kf[1] for kf in keyframes]
                
                # Times buffer
                time_bytes = struct.pack(f'<{len(times)}f', *times)
                time_bv = add_buffer_data(time_bytes)
                time_acc = len(accessors)
                accessors.append({
                    "bufferView": time_bv,
                    "byteOffset": 0,
                    "componentType": 5126,
                    "count": len(times),
                    "type": "SCALAR",
                    "min": [min(times)],
                    "max": [max(times)]
                })
                
                # Value buffer
                if prop_name == "rotation":
                    val_floats = [c for q in vals for c in q]
                    val_type = "VEC4"
                else:
                    val_floats = [c for t in vals for c in t]
                    val_type = "VEC3"
                    
                val_bytes = struct.pack(f'<{len(val_floats)}f', *val_floats)
                val_bv = add_buffer_data(val_bytes)
                val_acc = len(accessors)
                accessors.append({
                    "bufferView": val_bv,
                    "byteOffset": 0,
                    "componentType": 5126,
                    "count": len(vals),
                    "type": val_type
                })
                
                sampler_idx = len(samplers)
                samplers.append({
                    "input": time_acc,
                    "interpolation": "LINEAR",
                    "output": val_acc
                })
                
                channels.append({
                    "sampler": sampler_idx,
                    "target": {
                        "node": node_idx,
                        "path": prop_name
                    }
                })
                
        return {
            "name": anim_name,
            "channels": channels,
            "samplers": samplers
        }

    # 1. IDLE (Duration 3.0s, loopable)
    # Breathing: Torso subtle scale/translation, Head slight sway, Arms resting
    t_steps = [0.0, 0.75, 1.5, 2.25, 3.0]
    idle_torso_t = []
    idle_head_r = []
    idle_shield_t = []
    for t in t_steps:
        s = math.sin(2 * math.pi * t / 3.0)
        idle_torso_t.append((t, (0.0, 0.005 * s, 0.0)))
        idle_head_r.append((t, euler_to_quat(0.02 * s, 0.03 * math.sin(math.pi * t / 3.0), 0.0)))
        idle_shield_t.append((t, (0.0, 0.98 + 0.008 * s, 0.18)))
        
    animations.append(create_animation("idle", 3.0, {
        1: {"translation": idle_torso_t},
        2: {"rotation": idle_head_r},
        7: {"translation": idle_shield_t}
    }))

    # 2. GREETING (Duration 2.0s, wave gesture)
    # Right Shoulder raises up and Right Elbow bends and waves
    wave_r_shoulder_r = []
    wave_r_elbow_r = []
    wave_head_r = []
    t_wave = [0.0, 0.3, 0.6, 0.9, 1.2, 1.6, 2.0]
    for t in t_wave:
        if t < 0.3:
            # Raise arm
            frac = t / 0.3
            wave_r_shoulder_r.append((t, euler_to_quat(-0.2 * frac, 0.0, -1.3 * frac)))
            wave_r_elbow_r.append((t, euler_to_quat(0.0, 0.0, -0.6 * frac)))
            wave_head_r.append((t, euler_to_quat(0.0, 0.0, -0.05 * frac)))
        elif t <= 1.6:
            # Waving hand
            w_cycle = math.sin((t - 0.3) * math.pi * 4)
            wave_r_shoulder_r.append((t, euler_to_quat(-0.2, 0.0, -1.3)))
            wave_r_elbow_r.append((t, euler_to_quat(0.0, 0.0, -0.6 + 0.35 * w_cycle)))
            wave_head_r.append((t, euler_to_quat(0.0, 0.05 * w_cycle, -0.06)))
        else:
            # Return down
            frac = (2.0 - t) / 0.4
            wave_r_shoulder_r.append((t, euler_to_quat(-0.2 * frac, 0.0, -1.3 * frac)))
            wave_r_elbow_r.append((t, euler_to_quat(0.0, 0.0, -0.6 * frac)))
            wave_head_r.append((t, euler_to_quat(0.0, 0.0, -0.05 * frac)))

    animations.append(create_animation("greeting", 2.0, {
        5: {"rotation": wave_r_shoulder_r},
        6: {"rotation": wave_r_elbow_r},
        2: {"rotation": wave_head_r}
    }))

    # 3. EXPLAINING (Duration 2.5s, loopable gentle explanation)
    # Left and Right arms gesturing in sync, head nodding
    t_exp = [0.0, 0.6, 1.25, 1.9, 2.5]
    exp_l_arm_r = []
    exp_r_arm_r = []
    exp_head_r = []
    for t in t_exp:
        s1 = math.sin(2 * math.pi * t / 2.5)
        s2 = math.cos(2 * math.pi * t / 2.5)
        exp_l_arm_r.append((t, euler_to_quat(-0.4 - 0.15 * s1, 0.0, 0.35 + 0.1 * s2)))
        exp_r_arm_r.append((t, euler_to_quat(-0.4 + 0.15 * s1, 0.0, -0.35 - 0.1 * s2)))
        exp_head_r.append((t, euler_to_quat(0.06 * s1, 0.04 * s2, 0.0)))

    animations.append(create_animation("explaining", 2.5, {
        3: {"rotation": exp_l_arm_r},
        5: {"rotation": exp_r_arm_r},
        2: {"rotation": exp_head_r}
    }))

    # 4. SCANNING (Duration 3.0s, attentive pose, shield badge extends forward and glows)
    t_scan = [0.0, 0.75, 1.5, 2.25, 3.0]
    scan_torso_r = []
    scan_head_r = []
    scan_shield_t = []
    for t in t_scan:
        s = math.sin(2 * math.pi * t / 3.0)
        scan_torso_r.append((t, euler_to_quat(0.03, 0.12 * s, 0.0)))
        scan_head_r.append((t, euler_to_quat(-0.02, 0.18 * s, 0.0)))
        scan_shield_t.append((t, (0.05 * s, 0.98 + 0.02 * math.cos(2 * math.pi * t / 3.0), 0.24)))

    animations.append(create_animation("scanning", 3.0, {
        1: {"rotation": scan_torso_r},
        2: {"rotation": scan_head_r},
        7: {"translation": scan_shield_t}
    }))

    # 5. POINTING (Duration 2.0s, gentle point right/forward)
    t_pt = [0.0, 0.5, 1.2, 1.7, 2.0]
    pt_r_arm_r = []
    pt_r_elbow_r = []
    pt_head_r = []
    for t in t_pt:
        if t <= 0.5:
            f = t / 0.5
        elif t <= 1.5:
            f = 1.0
        else:
            f = (2.0 - t) / 0.5
        pt_r_arm_r.append((t, euler_to_quat(-0.7 * f, 0.0, -0.6 * f)))
        pt_r_elbow_r.append((t, euler_to_quat(-0.2 * f, 0.0, 0.1 * f)))
        pt_head_r.append((t, euler_to_quat(0.0, 0.15 * f, 0.0)))

    animations.append(create_animation("pointing", 2.0, {
        5: {"rotation": pt_r_arm_r},
        6: {"rotation": pt_r_elbow_r},
        2: {"rotation": pt_head_r}
    }))

    # 6. PROCESSING (Duration 2.0s, centered calm rhythmic movement)
    t_proc = [0.0, 0.5, 1.0, 1.5, 2.0]
    proc_torso_t = []
    proc_head_r = []
    for t in t_proc:
        s = math.sin(2 * math.pi * t / 2.0)
        proc_torso_t.append((t, (0.0, 0.008 * s, 0.0)))
        proc_head_r.append((t, euler_to_quat(0.04 * s, 0.0, 0.0)))

    animations.append(create_animation("processing", 2.0, {
        1: {"translation": proc_torso_t},
        2: {"rotation": proc_head_r}
    }))

    # 7. REASSURING (Duration 2.2s, gentle encouraging nod & calm posture)
    t_re = [0.0, 0.5, 1.0, 1.6, 2.2]
    re_head_r = []
    re_l_arm_r = []
    re_r_arm_r = []
    for t in t_re:
        nod = math.sin(math.pi * t / 1.1) if t <= 1.1 else 0.0
        re_head_r.append((t, euler_to_quat(0.12 * nod, 0.0, 0.0)))
        re_l_arm_r.append((t, euler_to_quat(-0.15 * nod, 0.0, 0.1 * nod)))
        re_r_arm_r.append((t, euler_to_quat(-0.15 * nod, 0.0, -0.1 * nod)))

    animations.append(create_animation("reassuring", 2.2, {
        2: {"rotation": re_head_r},
        3: {"rotation": re_l_arm_r},
        5: {"rotation": re_r_arm_r}
    }))

    # 8. PAUSED (Neutral still pose)
    animations.append(create_animation("paused", 1.0, {
        1: {"translation": [(0.0, (0.0, 0.0, 0.0)), (1.0, (0.0, 0.0, 0.0))]},
        2: {"rotation": [(0.0, (0.0, 0.0, 0.0, 1.0)), (1.0, (0.0, 0.0, 0.0, 1.0))]}
    }))

    # Build GLTF dictionary
    gltf_dict = {
        "asset": {
            "version": "2.0",
            "generator": "SafeLens 3D Female Guide Generator - Aria"
        },
        "scene": 0,
        "scenes": [
            {
                "name": "DefaultScene",
                "nodes": [0]
            }
        ],
        "nodes": nodes,
        "materials": materials,
        "meshes": meshes,
        "animations": animations,
        "accessors": accessors,
        "bufferViews": buffer_views,
        "buffers": [
            {
                "byteLength": len(bin_data)
            }
        ]
    }

    # Encode JSON
    json_bytes = json.dumps(gltf_dict, separators=(',', ':')).encode('utf-8')
    while len(json_bytes) % 4 != 0:
        json_bytes += b' ' # Space padding

    while len(bin_data) % 4 != 0:
        bin_data += b'\x00'

    # GLB Header
    total_length = 12 + 8 + len(json_bytes) + 8 + len(bin_data)
    header = struct.pack('<4sII', b'glTF', 2, total_length)
    chunk0_header = struct.pack('<II', len(json_bytes), 0x4E4F534A) # JSON
    chunk1_header = struct.pack('<II', len(bin_data), 0x004E4942)  # BIN

    glb_content = header + chunk0_header + json_bytes + chunk1_header + bin_data
    return glb_content

if __name__ == '__main__':
    out_path = r'c:\Users\Barathan\Desktop\bharadhan project\hidden_cam\hidden_cam\assets\avatar\safelens_avatar.glb'
    glb = build_gltf_model()
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, 'wb') as f:
        f.write(glb)
    print(f"Successfully generated {out_path} ({len(glb)} bytes)")
