export interface Repository<T> {
    save(item: Omit<T, 'id'>): Promise<T>;
}