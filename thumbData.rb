def get_thumb(prefix=nil,names_space_flag=false,finger_name="TH")

  ###### Material ####
  # https://rgbcolorpicker.com/0-1
  materials =[
   #colors used for visual
    {
          "name"=>"gray",
          "rgba"=>[0.4,0.4,0.4,1]
    },
    {
          "name"=>"yellow",
          "rgba"=>[0.866667, 0.866667, 0.0509804, 1],
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
        "joints"=>["joint1","joint2","joint3","joint4"],
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
  defaults = {

    #joints
    "j"=>{
      "axis"=> [0, 0, -1]
    }

  }

  ###### Links #######
  #TODO: add joints
  links = [
    {
      "childclass"=>"thumb",
      "name"=>"knuckle",
      "pos"=> [-0.0693952, -0.00124224, -0.0216224],
      "quat"=>[0.707107, 0, 0.707107, 0],
      "i"=>{
          "mass"=>0.032,
          "pos"=> [0, 0, 0],
          "quat"=>[0.709913, 0.704273, -0.000363156, 0.00475427],
          "di"=>[4.7981e-06, 4.23406e-06, 2.86184e-06] #diaginertia
      },
      "j"=>{
            "name"=>"j0",
            "range"=>[-0.349, 2.094]
      },
      "g_visual"=>[
          {
            "pos"=>[-0.00535664, 0.0003, 0.000784034],
            "quat"=>[0.5, -0.5, -0.5, -0.5],
            "mesh"=>"pip",
            "material"=>"yellow"
          }
      ]
    },
    {
      "name"=>"proximal",
      "pos"=> [0, 0.0143, -0.013],
      "quat"=>[0.5, 0.5, -0.5, 0.5],
      "i"=>{
          "mass"=>0.003,
          "pos"=> [0, 0, 0],
          "di"=>[5.93e-07, 5.49e-07, 2.24e-07] #diaginertia
      },
      "j"=>{
            "name"=>"j1",
            "range"=>[-0.47, 2.443]
      },
      "g_visual"=>[
          {  "pos"=>[0.0119619, 0, -0.0158526],
              "quat"=>[0.707107, 0.707107, 0, 0],
              "mesh"=>"thumb_pip",
              "material"=>"yellow"
          }
      ]
    },
    {
      "name"=>"middle",
      "pos"=> [0, 0.0145, -0.017],
      "quat"=>[0.707107, -0.707107, 0, 0],
      "i"=>{
          "mass"=>0.038,
          "pos"=> [0, 0, 0],
          "quat"=>[0.708624, 0.704906, 0.00637342, 0.0303153],
          "di"=>[8.48742e-06, 7.67823e-06, 3.82835e-06] #diaginertia
      },
      "j"=>{
            "name"=>"j2",
            "range"=>[-1.2, 1.9]
      },
      "g_visual"=>[
          {  "pos"=>[0.0439687, 0.057953, -0.00862868],
              "quat"=>[1, 0, 0, 0],
              "mesh"=>"thumb_dip",
              "material"=>"yellow"
          }
      ]
    },
    {
      "name"=>"distal",
      "pos"=> [0, 0.0466, 0.0002],
      "quat"=>[0, 0, 0, 1],
      "i"=>{
          "mass"=>0.049,
          "pos"=> [0, 0, 0],
          "quat"=>[0.704307, 0.709299, 0.006848, -0.0282727],
          "di"=>[2.03882e-05, 1.98443e-05, 4.32049e-06] #diaginertia
      },
      "j"=>{
            "name"=>"j3",
            "range"=>[-1.34, 1.88]
      },
      "g_visual"=>[
          {  "pos"=>[0.0625595, 0.0784597, 0.0489929],
              "mesh"=>"thumb_fingertip",
              "material"=>"yellow"
          }
      ]
    },
  ]

  ###### Actuators ########
  #TODO
  actuators = [
    {
      "name"  => "actuator1",
      "joint" => "j0",
      "ctrlrange"=>[-0.349, 2.094]
    },
    {
      "name"  => "actuator2",
      "joint" => "j1",
      "ctrlrange"=>[-0.47, 2.443]
    },
    {
      "name"  => "actuator3",
      "joint" => "j2",
      "ctrlrange"=>[-1.2, 1.9]
    },
    {
      "name"  => "actuator4",
      "joint" => "j3",
      "ctrlrange"=>[-1.34, 1.88]
    }
  ]

  ###### applying finger_name ####
  for i in 0..links.length-1
    l=links[i]
    if l.key?("name")
        l["name"] += "_"+finger_name
    end
    if l.key?("j")
      l["j"]["name"] += "_"+finger_name
    end
  end

  for i in 0..actuators.length-1
    a = actuators[i]
    if a.key?("joint")
      a["joint"] += "_"+finger_name
    end
  end

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
            l["g_col"][j]["class"]= name_space+"collision"+"_"+(i%2).to_s()
        end
    end
    if l.key?("j")
        l['j']["name"] = name_space+l['j']["name"]
    end
    links[i] = l
  end

  ###### assets #####
  meshes = [
  "pip.stl",
  "thumb_pip.stl",
  "thumb_dip.stl",
  "thumb_fingertip.stl"
  ]


  return links,contacts,actuators,meshes,materials,tendon,classes,defaults

end

def get_finger_joint_type(class_name)
  return "hinge"
end
