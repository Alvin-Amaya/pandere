import { Repository } from "@/infrastructure/prisma-repository";
import { db } from "@/infrastructure/client";
import { Project, User } from "./types";
import { ProjectService } from "./project";
import UserService from "./user";

const projectRepository = new Repository<Project>(db.project);
export const projectService = new ProjectService(projectRepository);

const userRepository = new Repository<User>(db.users);
export const userService = new UserService(userRepository);