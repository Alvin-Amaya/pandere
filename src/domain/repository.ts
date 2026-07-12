export interface IRepository<T> {
    findById(id: number): Promise<T | null>;
    getAll(): Promise<T[]>;
    save(item: Omit<T, 'id'>): Promise<T>;
    delete(id: number): Promise<void>;
}