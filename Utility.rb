
    require 'erb'
    require 'matrix'




  def euler_to_quaternion(rpy)
      roll  = rpy[0]
      pitch = rpy[1]
      yaw   = rpy[2]
      cy = Math.cos(yaw * 0.5)
      sy = Math.sin(yaw * 0.5)
      cp = Math.cos(pitch * 0.5)
      sp = Math.sin(pitch * 0.5)
      cr = Math.cos(roll * 0.5)
      sr = Math.sin(roll * 0.5)

      qw = cy * cp * cr + sy * sp * sr
      qx = cy * cp * sr - sy * sp * cr
      qy = sy * cp * sr + cy * sp * cr
      qz = sy * cp * cr - cy * sp * sr

      return [qw, qx, qy, qz]
  end

  def rgb256ToDecimal(rgba)
      r = rgba[0]/256.0
      g = rgba[1]/256.0
      b = rgba[2]/256.0
      #  a stand for opacity
      a = rgba[3]/256

      return [r,g,b,a]
  end

    def degreeToRadian(degrees)
      radians = degrees * Math::PI / 180
      return radians
    end

    def anglesToRadian(rpy_deg)
      r = degreeToRadian(rpy_deg[0])
      p = degreeToRadian(rpy_deg[1])
      y = degreeToRadian(rpy_deg[2])

      rpy = [r,p,y]

      return rpy

    end

    def a_to_s(v)#converts array to string
      Array(v).join(" ")
    end


    def produceKey(objs=[])
      qpos = []
      qvel  = []
      comment_xml = %{}

      for obj in objs do
        for joint in obj.joints do
          obj_comment = "#{obj.name}::#{joint.name}::#{joint.dof}"
          qpos += joint.qpos
          qvel += joint.qvel
          #TODO:: add obj comment to comment_xml
        end
      end

      return qpos,qvel
    end


    class Joint
      attr_accessor :xml,:qvel,:qpos,:name,:dof
      def initialize(type=nil,name="",axis=nil, pos=nil, range=nil,
                     euler=nil,class_dic=nil)

        @name = name
        @dof = 0

        if type=="free"
          #6DOF 3T3R
          @dof = 6
          # rotation is in quaternion
          @qpos = [0]*3 + [0]*4
        elsif type=="ball"
          #3DOF 3R
          @dof = 3
          @qpos = [0]*4
        elsif type=="slide"
          #1DOF 1T
          @dof = 1
          @qpos = [0]*1
        elsif type=="hinge"
          #1DOF 1R
          @dof = 1
          @qpos = [0]*1

        end


        @qvel = [0]*@dof

        #crate an ignore list values that are going to be in default are
        #going to be ignored


        name_xml  = name.nil?  ?        nil  :  %{ name="#{a_to_s(name)}" }.gsub(/^  /, '')
        axis_xml  = axis.nil?  ?        nil  :  %{ axis="#{a_to_s(axis)}" }.gsub(/^  /, '')
        pos_xml   = pos.nil?   ?        nil  :  %{pos= "#{a_to_s(pos)}"   }.gsub(/^  /, '')
        euler_xml = euler.nil? ?        nil  :  %{euler="#{a_to_s(euler)}"}.gsub(/^  /, '')
        range_xml = range.nil? ?        nil  :  %{range="#{a_to_s(range)}"}.gsub(/^  /, '')
        type_xml  = type.nil? ?         nil  :  %{type="#{type}"}.gsub(/^  /, '')

        class_xml = nil
        if class_dic

          #set attrbutes to ignore to nil
          for attrbiute in class_dic["ignore"] do

            if attrbiute =="axis"
              axis_xml=nil
            elsif attrbiute =="pos"
              pos_xml=nil
            elsif attrbiute =="euler"
              euler_xml=nil
            elsif attrbiute =="range"
              range_xml=nil
            elsif attrbiute =="type"
              type_xml=nil

            end

          end
          if class_dic.key?("name")
            class_xml = class_dic["name"].nil?  ?     nil :  %{class="#{class_dic["name"]}"}.gsub(/^  /, '')
          end
        end

        @xml = %{
          <joint #{name_xml} #{type_xml} #{axis_xml} #{pos_xml} #{euler_xml} #{range_xml} #{class_xml}/>
        }.gsub(/^  /, '')


      end
    end
