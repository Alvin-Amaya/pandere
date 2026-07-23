import type { 
    address,
    location,
    actor,
    users,
    person,
    project,
    project_task,
    project_has_skill,
    donation,
    donor,
    role,
    enterprise,
    currency,
    skill,
    volunteer,
    organization,
    job_title,
    staff,
    telephone,
    permission,
    expense,
    fund,
    file,
    status,
    budget_allocation,
    indicator,
    work_log,
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
export type ProjectTask = project_task;
export type jobTitle = job_title;
export type Staff = staff;
export type Telephone = telephone;
export type Permission = permission;
export type Expense = expense;
export type Fund = fund;
export type Location = location;
export type File = file;
export type Status = status;
export type BudgetAllocation = budget_allocation;
export type Indicator = indicator;
export type WorkLog = work_log;