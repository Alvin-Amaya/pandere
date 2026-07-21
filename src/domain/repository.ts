interface QueryOperators<V> {
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

type WhereConditions<T> = {
    [K in keyof T]?: T[K] | QueryOperators<T[K]>;
};

export type CreateInput<T> = Omit<T, 'id'> & Record<string, unknown>;
export type UpdateInput<T> = Partial<Omit<T, 'id'>> & Record<string, unknown>;

interface Where<T> {
    where: WhereConditions<T>;
}

interface IncludeMap {
    [key: string]: boolean | IncludeMap;
}

export interface Options<T> {
    where?: Where<T>;
    include?: IncludeMap;
}

export interface IRepository<T> {
    findById(id: number, options?: Options<T>): Promise<T | null>;
    getAll(options?: Options<T>): Promise<T[]>;
    create(item: CreateInput<T>): Promise<T>;
    update(id: number, item: UpdateInput<T>): Promise<T>;
    delete(id: number): Promise<T | void>;
}