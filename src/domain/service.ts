import { IRepository } from "@/domain/repository";

export class Service<T> {
    constructor(public readonly repository: IRepository<T>) {}

    async findById(id: number): Promise<T | null> {
        return await this.repository.findById(id);
    }
    
    async getAll(): Promise<T[]> {
        return await this.repository.getAll();
    }

    async create(item: Omit<T, 'id'>): Promise<T> {
        return await this.repository.create(item);
    }

    async update(id: number, item: Partial<Omit<T, 'id'>>): Promise<T> {
        return await this.repository.update(id, item);
    }

    async delete(id: number): Promise<void> {
        return await this.repository.delete(id);
    }
}