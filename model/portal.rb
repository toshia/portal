# -*- coding: utf-8 -*-
require_relative 'portal_photo'

module Plugin::Portal
  class World < Diva::Model
    register :portal, name: "Portal"

    field.string :slug, required: true
    field.string :name, required: true
    field.string :target_slug, required: true
    field.has :next_portal, Plugin::Portal::World, required: true

    def world
      Enumerator.new{|y| Plugin.filtering(:worlds, y) }.find{ |w|
        w.slug.to_sym == target_slug
      }
    end

    def name
      self[:name] || ''
    end

    def icon
      if next_portal
        Plugin::Portal::TiltPhoto.new(head: world.icon, tail: next_portal.icon)
      else
        world.icon
      end
    end

    def slug
      self[:slug].to_sym
    end

    def target_slug
      self[:target_slug].to_sym
    end

    def ===(other)
      self == other || self.next_portal === other
    end

    def respond_to?(method_name)
      world.respond_to?(method_name) || next_portal&.respond_to?(method_name)
    end

    def method_missing(method_name, *rest, &proc)
      if world.respond_to?(method_name)
        world.__send__(method_name, *rest, &proc)
      elsif next_portal
        next_portal.__send__(method_name, *rest, &proc)
      else
        super
      end
    end
  end
end
