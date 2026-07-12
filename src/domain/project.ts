import { IRepository } from "@/domain/repository";
import { Project } from "./types";

export class ProjectService {
    constructor(private readonly repository: IRepository<Project>) {}

    findById(id: number): Promise<Project | null> {
        return this.repository.findById(id);
    }
    getAll(): Promise<Project[]> {
        return this.repository.getAll();
    }
}