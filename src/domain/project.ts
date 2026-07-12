import { IRepository } from "@/domain/repository";
import { Project } from "./types";
import { Repository } from "@/infrastructure/prisma-repository";
import { db } from "@/infrastructure/client";

export class ProjectService {
    constructor(private readonly repository: IRepository<Project>) {}

    findById(id: number): Promise<Project | null> {
        return this.repository.findById(id);
    }
    getAll(): Promise<Project[]> {
        return this.repository.getAll();
    }
}

const projectRepository = new Repository<Project>(db.project);
export const projects = new ProjectService(projectRepository);