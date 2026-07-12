import { Repository } from "@/infrastructure/prisma-repository";
import { db } from "@/infrastructure/client";
import { Project } from "./types";
import { ProjectService } from "./project";

const projectRepository = new Repository<Project>(db.project);
export const projects = new ProjectService(projectRepository);