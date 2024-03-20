def get_finger(prefix=nil,names_space_flag=false,finger_name="FF")

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
    },
    "j1"=>{
        "range"=>[-0.314, 2.23],
        "ctrlrange"=>[-0.314, 2.23]
    },
    "j2"=>{
        "range"=>[-1.047, 1.047],
        "ctrlrange"=>[-1.047, 1.047]
    },
    "j3"=>{
        "range"=>[-0.506, 1.885],
        "ctrlrange"=>[-0.506, 1.885]
    },
    "j4"=>{
      "range"=>[-0.366, 2.042],
      "ctrlrange"=>[-0.366, 2.042]
    }

  }

  ###### Links #######
  #TODO: add joints
  links = [
    {
      "name"=>"knuckle",
      "pos"=> [-0.00709525, 0.0230578, -0.0187224],
      "quat"=>[0.5, 0.5, 0.5, -0.5],
      "i"=>{
          "mass"=>0.044,
          "pos"=> [0, 0, 0],
          "quat"=>[0.388585, 0.626468, -0.324549, 0.592628],
          "di"=>[1.47756e-05, 1.31982e-05, 6.0802e-06] #diaginertia
      },
      "j"=>{
            "name"=>"j0",
            "class"=>"joint1"
      },
      "g_visual"=>[
          {
            "pos"=>[0.0084069, 0.00776624, 0.0146574],
            "quat"=>[1, 0, 0, 0],
            "mesh"=>"mcp_joint",
            "material"=>"gray"
          }
      ]
    },
    {
      "name"=>"proximal",
      "pos"=> [-0.0122, 0.0381, 0.0145],
      "quat"=>[0.5, -0.5, -0.5, 0.5],
      "i"=>{
          "mass"=>0.032,
          "pos"=> [0, 0, 0],
          "quat"=>[0.709913, 0.704273, -0.000363156, 0.00475427],
          "di"=>[4.7981e-06, 4.23406e-06, 2.86184e-06] #diaginertia
      },
      "j"=>{
            "name"=>"j1",
            "class"=>"joint2"
      },
      "g_visual"=>[
          {  "pos"=>[0.00964336, 0.0003, 0.000784034],
              "quat"=>[0.5, -0.5, -0.5, -0.5],
              "mesh"=>"pip",
              "material"=>"yellow"
          }
      ]
    },
    {
      "name"=>"middle",
      "pos"=> [0.015, 0.0143, -0.013],
      "quat"=>[0.5, 0.5, -0.5, 0.5],
      "i"=>{
          "mass"=>0.037,
          "pos"=> [0, 0, 0],
          "quat"=>[-0.252689, 0.659216, 0.238844, 0.666735],
          "di"=>[6.68256e-06, 6.24841e-06, 5.02002e-06] #diaginertia
      },
      "j"=>{
            "name"=>"j2",
            "class"=>"joint3"
      },
      "g_visual"=>[
          {  "pos"=>[0.0211334, -0.00843212, 0.00978509],
              "quat"=>[0, -1, 0, 0],
              "mesh"=>"dip",
              "material"=>"yellow"
          }
      ]
    },
    {
      "name"=>"distal",
      "pos"=> [-4.08806e-09, -0.0361, 0.0002],
      "i"=>{
          "mass"=>0.016,
          "pos"=> [0, 0, 0],
          "quat"=>[0.706755, 0.706755, 0.0223155, 0.0223155],
          "di"=>[3.37527e-06, 2.863e-06, 1.54873e-06] #diaginertia
      },
      "j"=>{
            "name"=>"j3",
            "class"=>"joint4"
      },
      "g_visual"=>[
          {  "pos"=>[0.0132864, -0.00611424, 0.0145],
              "quat"=>[0, 1, 0, 0],
              "mesh"=>"fingertip",
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
      "class" => "joint1"
    },
    {
      "name"  => "actuator2",
      "joint" => "j1",
      "class" => "joint2"
    },
    {
      "name"  => "actuator3",
      "joint" => "j2",
      "class" => "joint3"
    },
    {
      "name"  => "actuator4",
      "joint" => "j3",
      "class" => "joint4"
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
        l['j']["class"] = name_space+l['j']["class"]
    end
    links[i] = l
  end

  ###### assets #####
  meshes = [
    "dip.stl",
    "pip.stl",
    "fingertip.stl",
    "mcp_joint.stl"
  ]


  return links,contacts,actuators,meshes,materials,tendon,classes,defaults

end

def get_finger_joint_type(class_name)
  return "hinge"
end
