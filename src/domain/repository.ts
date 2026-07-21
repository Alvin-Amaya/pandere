export interface QueryOperators<V> {
    equals?: V;
    contains?: V extends string ? string : never;
    startsWith?: V extends string ? string : never;
    endsWith?: string;
    gt?: V;  
    gte?: V; 
    lt?: V;  
    lte?: V; 
    in?: V[];
    notIn?: V[];
}

export type WhereConditions<T> = {
    [K in keyof T]?: T[K] | QueryOperators<T[K]>;
};

export type CreateInput<T> = Omit<T, 'id'> & Record<string, unknown>;
export type UpdateInput<T> = Partial<Omit<T, 'id'>> & Record<string, unknown>;

export interface Where<T> {
    where: WhereConditions<T>;
}

export interface IncludeMap {
    [key: string]: boolean | IncludeMap;
}

export interface IRepository<T> {
    findById(id: number, include?: Record<string, boolean | IncludeMap>): Promise<T | null>;
    getAll(include?: IncludeMap): Promise<T[]>;
    create(item: CreateInput<T>): Promise<T>;
    update(id: number, item: UpdateInput<T>): Promise<T>;
    delete(id: number): Promise<T | void>;
}