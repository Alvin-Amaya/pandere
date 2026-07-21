import { Repository } from "@/infrastructure/prisma-repository";
import { db } from "@/infrastructure/client";
import { Currency, Donation, Enterprise, Project, User } from "@/domain/types";
import { ProjectService } from "@/domain/project";
import { UserService } from "@/domain/actors";
import { Service } from "@/domain/service";

const projectRepository = new Repository<Project>(db.project);
export const projectService = new ProjectService(projectRepository);

const userRepository = new Repository<User>(db.users);
export const userService = new UserService(userRepository);

const donationRepository = new Repository<Donation>(db.donation);
export const donationService = new Service<Donation>(donationRepository);

const currencyRepository = new Repository<Currency>(db.currency);
export const currencyService = new Service<Currency>(currencyRepository);

const enterpriseRepository = new Repository<Enterprise>(db.enterprise);
export const enterpriseService = new Service<Enterprise>(enterpriseRepository);