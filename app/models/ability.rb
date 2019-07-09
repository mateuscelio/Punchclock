# frozen_string_literal: true

class Ability
  include CanCan::Ability
  prepend Draper::CanCanCan

  def initialize(user)
    if user.has_admin_access?
      admin_permitions(user)
    else
      user_permitions(user)
    end
  end

  private

  def admin_permitions(user)
    if user.super_admin?
      can :manage, :all
    else
      can :manage, [
        User,
        Office,
        Project,
        Client,
        RegionalHoliday,
        Allocation,
        Evaluation,
        Questionnaire,
        Skill
      ], company_id: user.company_id

      can :read, Punch, company_id: user.company_id
      can :read, ActiveAdmin::Page, name: "Dashboard"

      can :create, [
        User,
        Office,
        Project,
        Client,
        Allocation,
        Evaluation,
        Questionnaire,
        RegionalHoliday,
        Skill
      ]
    end

    cannot :destroy, [User, Project]
  end

  def user_permitions(user)
    can :manage, Punch, company_id: user.company_id, user_id: user.id
    can :read, User, company_id: user.company_id
    can %i[edit update], User, id: user.id 

    if !user.normal? || user.office_head?
      can :manage, Evaluation, company_id: user.company_id
      cannot %i[destroy edit update], Evaluation
    end
  end
end
