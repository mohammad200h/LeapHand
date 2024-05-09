def get_palm(prefix=nil,is_child=false,names_space_flag=false,finger_name="FF")

  ###### Material ####
  # https://rgbcolorpicker.com/0-1
  materials =[
   #colors used for visual
    {
      "name"=>"gray",
      "rgba"=>[0.4,0.4,0.4,1]
    },
    {
      "name"=>"red",
      "rgba"=>[0.603922, 0.14902, 0.14902, 1],
    },
   #colors used for collision groups
    {
      "name"=>"light_orange",
      "rgba"=>[1, 0.749, 0, 1]
    },
    {
      "name"=>"green",
      "rgba"=>[0.11, 1, 0, 0.2]
    }
  ]

  #TODO: change class names to appropriate names these belong to kuka
  classes ={
        "main"=>"hand",
        "visuals"=>["visual"],
        "inertia"=>"inertia",
        "collisions"=>["collision_0","collision_1"]
  }

  ##name_space##
  name_space = ""
  if names_space_flag
      name_space = classes["main"]+"/"

      classes.each_key do |key|
        if (classes[key].is_a? String) && !classes.key?("main")
            classes[key] =  classes["main"]+"/"+classes[key]
        elsif classes[key].is_a? Array
            for i in 0..classes[key].length-1 do
                classes[key][i] =  classes["main"]+"/"+classes[key][i]
            end
        end
      end
  end

  ###### Defaults ######
  defaults = nil

  ###### Links #######
  #TODO: add joints
  links = [
    {
      "name"=>"palm",
      "i"=>{
          "mass"=>0.044,
          "pos"=> [0, 0, 0],
          "quat"=>[0.388585, 0.626468, -0.324549, 0.592628],
          "di"=>[1.47756e-05, 1.31982e-05, 6.0802e-06] #diaginertia
      },
      "g_visual"=>[
          {
            "pos"=>[-0.0200952, 0.0257578, -0.0347224],
            "quat"=>[1, 0, 0, 0],
            "mesh"=>"palm_lower",
            "material"=>"red"
          }
      ],
      "g_inertia"=>[
          {
            "pos"=>[-0.0200952, 0.0257578, -0.0347224],
            "quat"=>[1, 0, 0, 0],
            "mesh"=>"palm_lower",
            "material"=>"gray"
          }
      ],
      "g_col"=>[
        {
          "name" => "palm_b_1",
          "type"=> "box",
          "pos"=> [-0.008,0.009,-0.01],
          "euler"=> [0,0,0],
          "size"=> [0.012,0.015,0.02],
          "mat"=>"green"
        },
        {
          "name" => "palm_b_2",
          "type"=> "box",
          "pos"=> [-0.008,-0.037,-0.01],
          "euler"=> [0,0,0],
          "size"=> [0.012,0.015,0.02],
          "mat"=>"green"
        },
        {
          "name" => "palm_b_3",
          "type"=> "box",
          "pos"=> [-0.008,-0.082,-0.01],
          "euler"=> [0,0,0],
          "size"=> [0.012,0.015,0.02],
          "mat"=>"green"
        },
        {
          "name" => "palm_b_4",
          "type"=> "box",
          "pos"=> [-0.041,-0.036,-0.01],
          "euler"=> [0,0,0],
          "size"=> [0.022,0.064,0.025],
          "mat"=>"green"
        },
        {
          "name" => "palm_b_5",
          "type"=> "box",
          "pos"=> [-0.082,-0.06,-0.01],
          "euler"=> [0,0,0],
          "size"=> [0.02,0.04,0.025],
          "mat"=>"green"
        },
      ]
    }
  ]

  if is_child
    links[0]["childclass"] = "leap"
  end

  ###### Actuators ########
  actuators = nil

  ###### Equality #####
  tendon = nil

  ###### Contacts ######
  contacts = nil

  ###### applying namespace ######
  for i in 0..links.length-1
    l=links[i]
    if l.key?("name")
        l["name"]= name_space+l["name"]
    end
    if l.key?("g_visual")
        for j in 0..l["g_visual"].length-1
            l["g_visual"][j]["class"]= name_space+"visual"
        end
    end
    if l.key?("g_col")
        for j in 0..l["g_col"].length-1
            l["g_col"][j]["class"]= name_space+"collision"+"_"+l["g_col"][j]["type"]
        end
    end
    if l.key?("j")
        l['j']["name"] = name_space+l['j']["name"]
        l['j']["class"] = name_space+l['j']["class"]
    end
    links[i] = l
  end

  ###### assets #####
  meshes = [
    "palm_lower.stl",
  ]


  return links,contacts,actuators,meshes,materials,tendon,classes,defaults

end

def get_palm_joint_type(class_name)
  return "fixed"
end
