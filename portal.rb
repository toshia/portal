# -*- coding: utf-8 -*-

require_relative "model/portal"
require_relative "cursed_spell"

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

  filter_search_spell do |yielder, name, models, optional|
    portals, others = models.partition{|model| model.class.slug == :portal }
    if portals.size == 1        # 複数のPortalが同時に使われるケースは対応してないんじゃ
      connect_to_parallel_world(yielder, name, others, optional, portals.first)
    end
    [yielder, name, models, optional]
  end

  def connect_to_parallel_world(yielder, name, models, optional, selected_portal)
    Enumerator.new{|fallback|
      Plugin.filtering(:search_spell, fallback, name, [selected_portal.world, *models], optional)
    }.each{|spell|
      yielder << Plugin::Portal::CursedSpell.new(spell, portal: selected_portal)
    }
    if selected_portal.next_portal
      connect_to_parallel_world(yielder, name, models, optional, selected_portal.next_portal)
    end
  end
end

