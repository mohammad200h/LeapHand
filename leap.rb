require 'erb'
require 'matrix'
require_relative "Utility"
require_relative "palm"
require_relative "thumb"
require_relative "finger"

require_relative "leapData"



class Leap
  attr_accessor :default_xml,:assets_xml,:body_xml,:contact_xml,
                :actuator_xml,:tendon_xml,:equality_xml,:name,:joints,:data
  def initialize(body_pose=[0,0,0,0,0,0,1],model="14",children=nil,
                 prefix=nil,is_child=false,compute_inertia=false)

    @name = "leap"

    ##### bodies #######
    #creating FF MF RF
    fingers_pos= {
      "FF"=>[-0.00709525,  0.0230578, -0.0187224],
      "MF"=>[-0.00709525, -0.0223922, -0.0187224],
      "RF"=>[-0.00709525, -0.0678422, -0.0187224]
    }
    finger_quat = [0.5, 0.5, 0.5, -0.5]
    fingers = []
    fingers_pos.each do |finger_name, pos|

      base_pose = pos + finger_quat
      finger = Finger.new(base_pose, finger_name)
      fingers.push(finger)

    end
    #creating TH
    th_pose =[-0.0693952, -0.00124224, -0.0216224]+[0.707107, 0, 0.707107, 0]
    thumb = Thumb.new(base_pose = th_pose,prefix=nil,is_child=true)
    #creating palm and attaching figners to plam
    children = fingers + [thumb]
    leap = Palm.new(body_pose,children,prefix=nil,is_child=true)
    #### assets #####
    meshes = []
    # adding fingers meshes
    f_mesh = fingers[0].data[3]
    f_mesh.each do |m|
      meshes.push(m)
    end
    # adding thumb meshes
    th_mesh = thumb.data[3]
    th_mesh.each do |m|
      meshes.push(m) unless meshes.include?(m)
    end
    # adding palm meshes
    p_mesh = leap.data[3]
    p_mesh.each do |m|
      meshes.push(m) unless meshes.include?(m)
    end

    materials = []
    # adding fingers materials
    f_material = fingers[0].data[4]
    f_material.each do |m|
      materials.push(m)
    end
    # adding thumb materials
    th_material = thumb.data[4]
    th_material.each do |m|
      materials.push(m) unless materials.include?(m)
    end
    # adding palm materials
    p_material = leap.data[4]
    p_material.each do |m|
      materials.push(m) unless materials.include?(m)
    end
    ##### actuators ######
    actuators = []
    fingers.each do |finger|
      actuators += finger.data[2]
    end
    actuators += thumb.data[2]


    ##### genrating assets #######

    @assets_xml = %{}
    materials.each do |m|
      @assets_xml += %{<material  name="#{m["name"]}" rgba="#{a_to_s(m["rgba"])}"/>}
    end

    meshes.each do |m|
      @assets_xml += %{<mesh file="#{m}"/>\n}

    end
    ###### genrating defaults ########
    #TODO
    class_name = @name
    @default_xml = %{
      <default class="#{class_name}">
        <default class="visual">
          <geom type="mesh" contype="0" conaffinity="0" group="2"/>
        </default>
        <default class="inertia">
         <geom type="mesh" group="4" />
        </default>
        <default class="collision_box">
            <geom group="3" type="box"   mass="0" material="green"/>
        </default>
        <joint axis="0 0 -1" damping="2000"/>
        <position kp="3000"/>
      </default>
    }.gsub(/^ /, '')
    ###### generating bodys #####
    #TODO
    @body_xml=%{
      #{leap.body_xml}
    }.gsub(/^ /, '')
    ########## genrating actuators ########
    @actuator_xml = %{}
    actuators.each do |a|
      @actuator_xml += %{
        <position class="#{@name}" name="#{a["name"]}" joint="#{a["joint"]}"  ctrlrange="#{a_to_s(a["ctrlrange"])}"/> \n\t\t
      }
    ########## contact exclusions ########
    contacts = get_leap()
    @contact_xml =%{}

        contacts.each do |contact|
          @contact_xml +=%{<exclude body1="#{contact["b1"]}" body2="#{contact["b2"]}"/>}.gsub(/^ /, '')
        end

    end

  end
end
