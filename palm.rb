require 'erb'
require 'matrix'
require_relative "Utility"
require_relative "palmData"
require_relative "link"


class Palm
  attr_accessor :default_xml,:assets_xml,:body_xml,:contact_xml,
                :actuator_xml,:tendon_xml,:equality_xml,:name,:joints,:data
  def initialize(body_pose=[0,0,0,0,0,0,1],children=[],
                 prefix=nil,is_child=false,compute_inertia=false)

    @name = "palm"
    @data = get_palm(prefix,is_child)
    links,contacts,actuators,meshes,materials,tendon,classes,defaults = @data
    @joints = []

    body_pos = body_pose.take(3)
    body_orn = body_pose.drop(3)

    ##### bodies #######
    collision_class = 0
    parent_link = nil
    palm_link = FingerLink.new(links[0],compute_inertia=true,children)

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
    #TODO
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
      </default>
    }.gsub(/^ /, '')
    ###### generating bodys #####
    #TODO
    @body_xml=%{
      #{palm_link.body_xml}
    }.gsub(/^ /, '')

  end
end
