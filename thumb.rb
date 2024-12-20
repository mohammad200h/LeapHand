require 'erb'
require 'matrix'
require_relative "Utility"
require_relative "thumbData"
require_relative "link"


class Thumb
  attr_accessor :default_xml,:assets_xml,:body_xml,:contact_xml,
                :actuator_xml,:tendon_xml,:equality_xml,:name,:joints,:data
  def initialize(body_pose=[0,0,0,0,0,0,1],
                 prefix=nil,is_child=false,compute_inertia=false)

    @name = "thumb"
    @data = get_thumb(prefix,is_child)
    links,contacts,actuators,meshes,materials,tendon,classes,defaults = @data
    @joints = []

    body_pos = body_pose.take(3)
    body_orn = body_pose.drop(3)


    ##### bodies #######
    collision_class = 0
    parent_link = nil
    child_link = FingerLink.new(links[links.length-1],compute_inertia)

    (links.length-1).downto(1) do |counter|
      if collision_class ==0
        collision_class = 1
      else
        collision_class = 0
      end
      parent_link = FingerLink.new(links[counter-1],compute_inertia,[child_link])
      # if base link
      if counter ==1
        parent_link = FingerLink.new(links[counter-1],compute_inertia,[child_link],collision_class,body_pose)
      end
      child_link = parent_link
    end


    #### assets #####
    asset_path = File.join(File.dirname(__FILE__),'assets')
    for i in 0...meshes.length
      meshes[i] = asset_path+"/"+meshes[i]
    end
    ##### genrating assets #######
    class_name = @name
    @assets_xml = %{}

    materials.each do |m|
      @assets_xml += %{<material  name="#{m["name"]}" rgba="#{a_to_s(m["rgba"])}"/>}

    end

    meshes.each do |m|
      @assets_xml += %{<mesh file="#{m}"/>\n}

    end
    ###### genrating defaults ########
    joints_and_acuators_xml = %{<joint axis="#{a_to_s(defaults["j"]["axis"])}" damping="2000"/>}


    @default_xml = %{
      <default class="#{class_name}">
        <material specular="0.5" shininess="0.25" />
        <default class="visual">
          <geom type="mesh" contype="0" conaffinity="0" group="2"/>
        </default>
        <default class="collision_box">
            <geom group="3" type="box"   mass="0" material="green"/>
        </default>
        #{joints_and_acuators_xml}
      </default>
    }.gsub(/^ /, '')
    ###### generating bodys #####
    @body_xml=%{
       #{parent_link.body_xml}
    }.gsub(/^ /, '')

     ########## genrating actuators ########
     @actuator_xml = %{}
     actuators.each do |a|
      class_xml = a["class"].nil? ? nil:%{class="#{a["class"]}"}
      @actuator_xml += %{
         <position name="#{a["name"]}" joint="#{a["joint"]}"  ctrlrange="#{a_to_s(a["ctrlrange"])}" kp="2000"/> \n\t\t}
     end

  end
end
