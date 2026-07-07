export interface IRepository<T> {
    findById(id: number): Promise<T>;
    save(item: Omit<T, 'id'>): Promise<T>;
}