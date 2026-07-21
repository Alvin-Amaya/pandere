import type { 
    address,
    actor,
    users,
    person,
    project,
    project_has_skill,
    donation,
    donor,
    role,
    enterprise,
    currency,
    skill,
    volunteer,
    organization,
} from "@prisma/client";

export type Project = project;
export type Actor = actor;
export type User = users;
export type Person = person;
export type Donation = donation;
export type Donor = donor;
export type Role = role;
export type Enterprise = enterprise;
export type Currency = currency;
export type Skill = skill;
export type ProjectSkill = project_has_skill;
export type Address = address;
export type Volunteer = volunteer;
export type Organization = organization;