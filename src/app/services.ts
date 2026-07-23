import { IDataModel, Repository } from "@/infrastructure/prisma-repository";
import { db } from "@/infrastructure/client";
import { ProjectService } from "@/domain/project";
import { UserService, VolunteerService } from "@/domain/actors";
import { Service } from "@/domain/service";
import { 
    Currency, 
    Donation, 
    Enterprise, 
    Project, 
    User, 
    Volunteer, 
    ProjectTask, 
    Role,
    Skill,
    Staff,
    Telephone,
    Fund,
    Status,
    BudgetAllocation,
    Indicator,
    // WorkLog,
    Expense
} from "@/domain/types";

const projectRepository = new Repository<Project>(db.project);
export const projectService = new ProjectService(projectRepository);

const userRepository = new Repository<User>(db.users);
export const userService = new UserService(userRepository);

const volunteerRepository = new Repository<Volunteer>(db.volunteer);
export const volunteerService = new VolunteerService(volunteerRepository);

export const donationService = serviceFactory<Donation>(db.donation);
export const currencyService = serviceFactory<Currency>(db.currency);
export const enterpriseService = serviceFactory<Enterprise>(db.enterprise);
export const projectTaskService = serviceFactory<ProjectTask>(db.project_task);
export const roleService = serviceFactory<Role>(db.role);
export const skillService = serviceFactory<Skill>(db.skill);
export const staffService = serviceFactory<Staff>(db.staff);
export const telephoneService = serviceFactory<Telephone>(db.telephone);
export const fundService = serviceFactory<Fund>(db.fund);
export const statusService = serviceFactory<Status>(db.status);
export const budgetAllocationService = serviceFactory<BudgetAllocation>(db.budget_allocation);
export const indicatorService = serviceFactory<Indicator>(db.indicator);
export const expenseService = serviceFactory<Expense>(db.expense);
// export const locationService = serviceFactory<Location>(db.location);
// export const fileService = serviceFactory<File>(db.file);
// export const workLogService = serviceFactory<WorkLog>(db.work_log);

function serviceFactory<T>(db: IDataModel<T>): Service<T> {
    return new Service<T>(new Repository<T>(db));
}