# -*- coding: utf-8 -*-

module Plugin::Portal
  class CursedSpell < Delegator
    def initialize(spell, portal:)
      @pure_spell = spell
      @portal = portal
    end

    def __getobj__
      @pure_spell
    end

    def self.metamorphose(method_name)
      define_method(method_name) do |models, *rest|
        @pure_spell.__send__(
          method_name,
          models.map{|m|
            m === @portal ? @portal.world : m
          },
          *rest)
      end
    end

    metamorphose(:call)
    metamorphose(:condition?)
    metamorphose(:match)
  end
end
