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