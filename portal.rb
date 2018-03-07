# -*- coding: utf-8 -*-

require_relative "model/portal.rb"

Plugin.create :portal do
  world_setting(:portal, "Portal") do
    input "このPortalの名前（任意）", :name
    select("Primary World", :primary) do
      Enumerator.new{|y| Plugin.filtering(:worlds, y) }.each do |world|
        option(world.slug, world.title)
      end
    end

    select("Secondary World", :secondary) do
      Enumerator.new{|y| Plugin.filtering(:worlds, y) }.each do |world|
        option(world.slug, world.title)
      end
    end
    values = await_input
    Plugin::Portal::World.new(
      slug: SecureRandom.uuid,
      name: values[:name],
      target_slug: values[:primary],
      next_portal: Plugin::Portal::World.new(
        slug: SecureRandom.uuid,
        name: values[:name],
        target_slug: values[:secondary],
        next_portal: nil))
  end
end
