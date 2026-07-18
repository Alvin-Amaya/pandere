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

export interface Where<T> {
    where: WhereConditions<T>;
}

export interface IncludeMap {
    [key: string]: boolean | IncludeMap;
}


export interface IRepository<T> {
    findById(id: number, include?: Record<string, boolean | IncludeMap>): Promise<T | null>;
    getAll(include?: IncludeMap): Promise<T[]>;
    create(item: Omit<T, 'id'>): Promise<T>;
    update(id: number, item: Partial<Omit<T, 'id'>>): Promise<T>;
    delete(id: number): Promise<T | void>;
}