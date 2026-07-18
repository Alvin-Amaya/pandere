import { IncludeMap, IRepository } from "@/domain/repository";

export class Service<T> {
    constructor(public readonly repository: IRepository<T>) {}

    async findById(id: number, include?: IncludeMap): Promise<T | null> {
        return await this.repository.findById(id, include);
    }
    
    async getAll(include?: IncludeMap): Promise<T[]> {
        return await this.repository.getAll(include);
    }

    async create(item: Omit<T, 'id'>): Promise<T> {
        return await this.repository.create(item);
    }

    async update(id: number, item: Partial<Omit<T, 'id'>>): Promise<T> {
        return await this.repository.update(id, item);
    }

    async delete(id: number): Promise<void> {
        await this.repository.delete(id);
    }
}