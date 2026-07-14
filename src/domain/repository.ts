export interface IRepository<T> {
    findById(id: number, include?: Record<string, boolean | any>): Promise<T | null>;
    getAll(): Promise<T[]>;
    create(item: Omit<T, 'id'>): Promise<T>;
    update(id: number, item: Partial<Omit<T, 'id'>>): Promise<T>;
    delete(id: number): Promise<void>;
}